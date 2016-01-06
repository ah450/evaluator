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
            unverified_login: 'Must be verified to login',
            incorrect_reset_token: 'Incorrect reset token',
            incorrect_verification_token: 'Incorrect verification token',
            too_soon: 'Please calm down',
            bad_request: 'Bad Request',
            internal_server_error: 'Internal Server error'
        },
        default_token_exp: 24.hours,
        messages: {
            registration_success: "Registered to course",
            unregistration_success: "Unregistered from course"
        },
        verification_expiration: 5.hours,
        pass_reset_expiration: 24.hours,
        user_verification_resend_delay: 3.hours,
        pass_reset_resend_delay: 30.minutes
    }

