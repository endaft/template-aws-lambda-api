#################################################
# Input Configuration Values
#################################################

variable "env" {
  type        = string
  default     = "dev"
  description = "The deployment environment or stage. Use 'production' to eliminate environment prefixes and set the API Gateway Stage to production."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "The default tgs to assign the created resources."
}

variable "app_name" {
  type        = string
  description = "The app name"
}

variable "app_domain" {
  type        = string
  description = "The app domain name"
}

variable "log_retention_days" {
  type        = number
  default     = 14
  description = "The number of days to retain log files. Default: 14"
}

variable "local_dev_endpoint" {
  type        = string
  default     = "http://localhost:19006"
  description = "The local development server endpoint, like http://localhost:19006. Defaults to: http://localhost:19006"
}

variable "anonymous" {
  type        = bool
  default     = false
  description = "Ultimately, controls the Cognito deployment. Set this to `true` skip deploying Cognito."
}

variable "cognito_logo_path" {
  type        = string
  default     = ""
  description = "The path to a logo file for Cognito. Ideally, 350px wide. MUST not exceed 100kb."
}

variable "cognito_css_path" {
  type        = string
  default     = ""
  description = "The path to a CSS file for Cognito. See schema comments for help."
}

variable "web_apps" {
  type        = map(string)
  default     = {}
  description = "The mapping of sub-domains (key) to bucket resource paths (value)."
}

variable "request_params" {
  type        = map(string)
  default     = {}
  description = "The request parameter mapping for the lambda integration."
}

variable "identity_providers" {
  type = list(object({
    name    = string
    type    = string
    mapping = map(string)
    details = map(string)
  }))
  default     = []
  description = "The user pool identity providers to be connected."
}

variable "token_validity" {
  type = object({
    id_token = object({
      duration = number
      units    = string
    })
    access_token = object({
      duration = number
      units    = string
    })
    refresh_token = object({
      duration = number
      units    = string
    })
  })
  default = {
    id_token = {
      duration = 30
      units    = "days"
    }
    access_token = {
      duration = 1
      units    = "hours"
    }
    refresh_token = {
      duration = 1
      units    = "hours"
    }
  }
  description = "The password complexity rules used by the user pool."
}

variable "password_rules" {
  type = object({
    minimum_length    = number
    require_numbers   = bool
    require_symbols   = bool
    require_lowercase = bool
    require_uppercase = bool
  })
  default = {
    minimum_length    = 10
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }
  description = "The password complexity rules used by the user pool."
}

variable "lambda_configs" {
  type = map(object({
    runtime          = string,
    memory           = number,
    timeout          = number,
    file             = string,
    handler          = string,
    description      = string,
    anonymous        = bool,
    architecture     = string,
    cloudfront_event = string,
    environment      = map(string),
    routes = set(object({
      method = string,
      path   = string
    }))
  }))
  description = "A map of name-keyed map of lambda configurations."
}
