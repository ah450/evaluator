# Application wide options shared with client side

Rails.application.config.configurations = {
        error_messages: {
            expired_token: "Token has expired",
            token_verification: "Unable to verify Token",
            forbidden: "Forbidden",
            authentication_error: "Authentication Error",
            argument_error: "Argument error",
            record_not_found: "Record not found",
            forbidden_teacher_only: "Must be a teacher to perform this action",
            unverified_login: 'Must be verified to login'
        },
        default_token_exp: 24.hours,
        messages: {
            registration_success: "Registered to course",
            unregistration_success: "Unregistered from course"
        },
        verification_expiration: 5.hours,
        pass_reset_expiration: 24.hours
    }

