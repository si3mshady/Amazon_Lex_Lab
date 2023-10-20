provider "aws" {
  region = "us-east-1" # Set your desired AWS region
}

resource "aws_lex_bot" "restaurant_order_bot" {
  name = "RestaurantOrderBot"
  description = "Bot for Food Ordering"
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
      content = "I didn't understand you, what would you like to order?"
    }
  }

  idle_session_ttl_in_seconds = 600
  process_behavior = "BUILD"
  voice_id = "Salli"

  intent {
    intent_name = aws_lex_intent.order_food.name
    intent_version = "$LATEST"
  }

  intent {
    intent_name = aws_lex_intent.cancel_order.name
    intent_version = "$LATEST"
  }

  intent {
    intent_name = aws_lex_intent.get_order_status.name
    intent_version = "$LATEST"
  }
}

resource "aws_lex_intent" "order_food" {
  name = "OrderFood"
  description = "Intent to order food from a restaurant"
  create_version = false

  sample_utterances = [
    "I want to order food.",
    "Can I get some food from your restaurant?",
    "I'd like to place an order for delivery.",
    "What's on the menu today?",
    "How can I place an order for takeout?",
    "I'm hungry. What can I order?",
    "Do you have any specials for today?",
    "I need to order some food for pickup.",
    "Tell me about your food options.",
    "I'm looking to get some food delivered."
]

  confirmation_prompt {
    max_attempts = 2

    message {
      content_type = "PlainText"
      content = "Sure, I can help you with that. Please provide the items you want to order and any specific instructions."
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
    name = "OrderItems"
    description = "The items to be ordered"
    priority = 1
    slot_constraint = "Required"
    slot_type = "CUSTOM_FOOD_ITEMS" # You can define a custom slot type for food items

    sample_utterances = ["I want to order {OrderItems}"]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content_type = "PlainText"
        content = "What items would you like to order? Please provide a list of items and any special requests."
      }
    }
  }
}

resource "aws_lex_intent" "cancel_order" {
  name = "CancelOrder"
  description = "Intent to cancel a food order"
  create_version = false

  sample_utterances = [
    "I want to cancel my order.",
    "Cancel my food order.",
    "I need to change my order.",
    "Can I modify my order?",
    "Is it possible to cancel my food delivery?",
    "I'd like to change my order details.",
    "I changed my mind, I want to cancel my order.",
    "How can I update my order?",
    "I have a change in my food order.",
    "Is it too late to cancel my order?"
]

  confirmation_prompt {
    max_attempts = 2

    message {
      content_type = "PlainText"
      content = "Of course, I can assist you with canceling your order. Please provide the order number or any relevant details."
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
    name = "OrderNumber"
    description = "The order number"
    priority = 1
    slot_constraint = "Required"
    slot_type = "AMAZON.NUMBER"

    sample_utterances = ["I want to cancel my order with order number {OrderNumber}"]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content_type = "PlainText"
        content = "Please provide your order number or relevant order details."
      }
    }
  }
}

resource "aws_lex_intent" "get_order_status" {
  name = "GetOrderStatus"
  description = "Intent to retrieve order status"
  create_version = false

  sample_utterances = [
    "Tell me about my order.",
    "What's the status of my food order?",
    "Give me details about my delivery.",
    "Can you provide information on my order?",
    "I'd like to know the status of my delivery.",
    "Check the status of my food order, please.",
    "Tell me about my recent order.",
    "What's the update on my food delivery?",
    "Can you give me an update on my order?",
    "I want to track my food order."
]

  confirmation_prompt {
    max_attempts = 2

    message {
      content_type = "PlainText"
      content = "I can help you with that. Please provide your order number or your name, and I will retrieve your order status."
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
    name = "OrderNumber"
    description = "The order number"
    priority = 1
    slot_constraint = "Required"
    slot_type = "AMAZON.NUMBER"

    sample_utterances = [
    "Tell me about my order with order number {OrderNumber}",
    "What's the status of my order with order number {OrderNumber}?",
    "Give me details about my delivery with order number {OrderNumber}.",
    "I'd like to check the status of my order with order number {OrderNumber}.",
    "Can you provide information about my order with order number {OrderNumber}?",
    "Check my order status for order number {OrderNumber}.",
    "I want to know the status of my order with order number {OrderNumber}.",
    "Please give me updates on my order with order number {OrderNumber}.",
    "What can you tell me about my order with order number {OrderNumber}?",
    "Provide me with the status of my order with order number {OrderNumber}."
]

    value_elicitation_prompt {
      max_attempts = 2

      message {
        content_type = "PlainText"
        content = "Please provide your order number or your name."
      }
    }
  }
}
