provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}

resource "aws_lex_bot" "dental_appointment_bot" {
  name = "DentalAppointmentBot"
  description = "Bot for Dental Appointments"
  create_version = false
  locale = "en-US"

  abort_statement {
    message {
      content_type = "PlainText"
      content = "Sorry, I am not able to assist at this time"
    }
  }

  child_directed = false

  clarification_prompt {
    max_attempts = 2
    message {
      content_type = "PlainText"
      content = "I didn't understand you, what would you like to do?"
    }
  }

  idle_session_ttl_in_seconds = 600
  process_behavior = "BUILD"
  voice_id = "Salli"

  intent {
    intent_name = aws_lex_intent.schedule_appointment.name
    intent_version = "$LATEST" # Use $LATEST for built-in intents
  }

  intent {
    intent_name = aws_lex_intent.cancel_appointment.name
    intent_version = "$LATEST" # Use $LATEST for built-in intents
  }

  intent {
    intent_name = aws_lex_intent.get_appointment_details.name
    intent_version = "$LATEST" # Use $LATEST for built-in intents
  }
}
resource "aws_lex_intent" "schedule_appointment" {
  name             = "ScheduleAppointment"
  description      = "Intent to schedule dental appointments"
  create_version   = false

  sample_utterances = [
    "I want to schedule an appointment.",
    "Can I book a dentist appointment.",
    "I need to set up a dental checkup.",
  ]

  confirmation_prompt {
    max_attempts = 2

    message {
      content_type = "PlainText"
      content = "Sure, I can help you with that. Please provide the date and time for your appointment."
    }
  }

  rejection_statement {
    message {
      content_type = "PlainText"
      content = "I'm sorry, I cannot assist you at this time."
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }

  slot {
    name        = "Date"
    description = "The date for the appointment"
    priority    = 1
    slot_constraint   = "Required"
    slot_type         = "AMAZON.DATE"

    sample_utterances = ["I want to schedule an appointment on {Date}"]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content_type = "PlainText"
        content = "On what date would you like to schedule the appointment"
      }
    }
  }

  slot {
    name        = "Time"
    description = "The time for the appointment"
    priority    = 2
    slot_constraint   = "Required"
    slot_type         = "AMAZON.TIME"

    sample_utterances = ["I want to schedule an appointment at {Time}"]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content_type = "PlainText"
        content = "At what time would you like to schedule the appointment"
      }
    }
  }
}

resource "aws_lex_intent" "cancel_appointment" {
  name             = "CancelAppointment"
  description      = "Intent to cancel dental appointments"
  create_version   = false

  sample_utterances = [
    "I want to cancel my appointment.",
    "Cancel my dentist appointment.",
    "I need to reschedule my dental checkup.",
  ]

  confirmation_prompt {
    max_attempts = 2

    message {
      content_type = "PlainText"
      content = "Of course, I can assist you with canceling your appointment. Please provide the appointment reference or the date and time of your appointment."
    }
  }

  rejection_statement {
    message {
      content_type = "PlainText"
      content = "I'm sorry, I cannot assist you at this time."
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }

  slot {
    name        = "AppointmentReference"
    description = "The appointment reference"
    priority    = 1
    slot_constraint   = "Required"
    slot_type         = "AMAZON.NUMBER"

    sample_utterances = ["I want to cancel my appointment with reference {AppointmentReference}"]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content_type = "PlainText"
        content = "Please provide your appointment reference."
      }
    }
  }
}

resource "aws_lex_intent" "get_appointment_details" {
  name             = "GetAppointmentDetails"
  description      = "Intent to retrieve appointment details"
  create_version   = false

  sample_utterances = [
    "Tell me about my appointment.",
    "What's the date of my dentist appointment",
    "Give me details about my dental checkup.",
  ]

  confirmation_prompt {
    max_attempts = 2

    message {
      content_type = "PlainText"
      content = "I can help you with that. Please provide your appointment reference or your name, and I will retrieve your appointment details."
    }
  }

  rejection_statement {
    message {
      content_type = "PlainText"
      content = "I'm sorry, I cannot assist you at this time."
    }
  }

  fulfillment_activity {
    type = "ReturnIntent"
  }

  slot {
    name        = "AppointmentReference"
    description = "The appointment reference"
    priority    = 1
    slot_constraint   = "Required"
    slot_type         = "AMAZON.NUMBER"

    sample_utterances = ["Tell me about my appointment with reference {AppointmentReference}"]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content_type = "PlainText"
        content = "Please provide your appointment reference or your name."
      }
    }
  }
}
