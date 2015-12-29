# Application wide options shared with client side

Rails.application.config.configurations = {
        error_messages: {
            expired_token: "Token has expired",
            token_verification: "Unable to verify Token",
            forbidden: "Forbidden",
            authentication_error: "Authentication Error",
            argument_error: "Argument error",
            record_not_found: "Record not found",
            forbidden_teacher_only: "Must be a teacher to perform this action"
        },
        default_token_exp: 24 * 60 * 60
    }

