// 'package main': Declares the package name. The 'main' package is
// special in Go, it's where the execution of the program starts.
package main

// 'fmt' is short for the 'format' package, which contain functions
// for formatted I/O.
import (
	"encoding/json"
	"bytes"
	"context"
	"fmt"
	"log"
	"net/http"
	"github.com/google/uuid"
	"github.com/hashicorp/terraform-plugin-sdk/v2/diag"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)

// 'func main()': Defines the main function, the entry point of the
// application. When you run the program, it starts executing from
// this function.
func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
	// Format.PrintLine
	// Prints to standard output
	fmt.Println("Hello, world!")
}

type Config struct {
	Endpoint string
	Token string
	UserUuid string
}

// In golang a titlecase function will get exported.
func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{
			"terratowns_home": Resource(),
		},
		DataSourcesMap: map[string]*schema.Resource{

		},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type: schema.TypeString,
				Required: true,
				Description: "The endpoint the external service.",
			},
			"token": {
				Type: schema.TypeString,
				Sensitive: true, // Mark the token as sensitive which hides it in the logs.
				Required: true,
				Description: "Bearer token for authorization.",
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,
				Description: "UUID for configuration.",
				ValidateFunc: validateUUID,
			},
		},
	}
	p.ConfigureContextFunc = providerConfigure(p)
	return p
}

func validateUUID(v interface{}, k string) (ws []string, errors []error) {
	log.Print("validateUUID:start")
	value := v.(string)
	if _, err := uuid.Parse(value); err != nil {
		errors = append(errors, fmt.Errorf("invalid UUID format"))
	}
	log.Print("validateUUID:end")
	return
}

func providerConfigure(p *schema.Provider) schema.ConfigureContextFunc {
	return func(ctx context.Context, d *schema.ResourceData) (interface{}, diag.Diagnostics) {
		log.Print("providerConfigure:start")
		config := Config{
			Endpoint: d.Get("endpoint").(string),
			Token:    d.Get("token").(string),
			UserUuid: d.Get("user_uuid").(string),
		}
		log.Print("providerConfigure:end")
		return &config, nil
	}
}

func Resource() *schema.Resource {
	log.Print("Resource:start")
	resource := &schema.Resource{
		CreateContext: resourceHomeCreate,
		ReadContext: resourceHomeRead,
		UpdateContext: resourceHomeUpdate,
		DeleteContext: resourceHomeDelete,
		Schema: map[string]*schema.Schema{
			"name": {
				Type: schema.TypeString,
				Required: true,
				Description: "Name of the home.",
			},
			"description": {
				Type: schema.TypeString,
				Required: true,
				Description: "Description of the home.",
			},
			"domain_name": {
				Type: schema.TypeString,
				Required: true,
				Description: "Domain name of home. Ex., *.cloudfront.net",
			},
			"town": {
				Type: schema.TypeString,
				Required: true,
				Description: "TerraTowns town to which the home belongs.",
			},
			"content_version": {
				Type: schema.TypeInt,
				Required: true,
				Description: "Content version of the home.",
			},
		},
	}
	log.Print("Resource:end")
	return resource
}

func resourceHomeCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	log.Print("resourceHomeCreate:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	payload := map[string]interface{}{
		"name": d.Get("name").(string),
		"description": d.Get("description").(string),
		"domain_name": d.Get("domain_name").(string),
		"town": d.Get("town").(string),
		"content_version": d.Get("content_version").(int),
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}

	// Construct the HTTP Request
	url := config.Endpoint+"/u/"+config.UserUuid+"/homes"
	log.Print("URL: " + url)
	req, err := http.NewRequest("POST", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return diag.FromErr(err)
	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// Parse response JSON
	var responseData map[string]interface{}
	if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
		return diag.FromErr(err)
	}

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to create home resource, status_code: %d, status: %s, body %s", resp.StatusCode, resp.Status, responseData))
	}

	homeUUID := responseData["uuid"].(string)
	d.SetId(homeUUID)

	log.Print("resourceHomeCreate:end")
	return diags
}

func resourceHomeRead(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	log.Print("resourceHomeRead:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	// Construct the HTTP Request
	url := config.Endpoint+"/u/"+config.UserUuid+"/homes/"+homeUUID
	log.Print("URL: " + url)
	req, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return diag.FromErr(err)
	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	var responseData map[string]interface{}

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode == http.StatusOK {
		// Parse response JSON
		if err := json.NewDecoder(resp.Body).Decode(&responseData); err != nil {
			return diag.FromErr(err)
		}
		d.Set("name",responseData["name"].(string))
		d.Set("description",responseData["description"].(string))
		d.Set("domain_name",responseData["domain_name"].(string))
		d.Set("content_version",responseData["content_version"].(float64))
	} else if resp.StatusCode == http.StatusNotFound {
		d.SetId("")
	} else if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to read home resource, status_code: %d, status: %s, body %s", resp.StatusCode, resp.Status, responseData))
	}

	log.Print("resourceHomeRead:end")
	return diags
}

func resourceHomeUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	log.Print("resourceHomeUpdate:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	payload := map[string]interface{}{
		"name": d.Get("name").(string),
		"description": d.Get("description").(string),
		"content_version": d.Get("content_version").(int),
	}
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return diag.FromErr(err)
	}

	// Construct the HTTP Request
	url := config.Endpoint+"/u/"+config.UserUuid+"/homes/"+homeUUID
	log.Print("URL: " + url)
	req, err := http.NewRequest("PUT", url, bytes.NewBuffer(payloadBytes))
	if err != nil {
		return diag.FromErr(err)
	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to update home resource, status_code: %d, status: %s", resp.StatusCode, resp.Status))
	}

	d.Set("name",payload["name"])
	d.Set("description",payload["description"])
	d.Set("content_version",payload["content_version"])

	log.Print("resourceHomeUpdate:end")
	return diags
}

func resourceHomeDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics{
	log.Print("resourceHomeDelete:start")
	var diags diag.Diagnostics

	config := m.(*Config)

	homeUUID := d.Id()

	// Construct the HTTP Request
	url := config.Endpoint+"/u/"+config.UserUuid+"/homes/"+homeUUID
	log.Print("URL: " + url)
	req, err := http.NewRequest("DELETE", url, nil)
	if err != nil {
		return diag.FromErr(err)
	}

	// Set Headers
	req.Header.Set("Authorization", "Bearer "+config.Token)
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")

	client := http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return diag.FromErr(err)
	}
	defer resp.Body.Close()

	// StatusOK = 200 HTTP Response Code
	if resp.StatusCode != http.StatusOK {
		return diag.FromErr(fmt.Errorf("failed to delete home resource, status_code: %d, status: %s", resp.StatusCode, resp.Status))
	}

	d.SetId("")

	log.Print("resourceHomeDelete:end")
	return diags
}
