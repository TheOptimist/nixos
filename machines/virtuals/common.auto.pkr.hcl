variable cpus {
  type = number
  default = 8
}

variable memory {
  type = number
  default = 16384
}

variable capacity { 
  type = string
  default = "32G"
}

variable localUser {
  type = string
  default = "george"
}

variable localUserPassword {
  type = string
  default = "password"
}

variable administratorPassword {
  type = string
  default = "password"
}