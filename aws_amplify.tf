# resource "aws_amplify_app" "frontend" {

#   name = "react_frontend"

#   repository = "https://github.com/Varma-PA/csye-frontend"

#   enable_branch_auto_build = true

#   build_spec = <<-EOT
#         version: 1
#         frontend:

#         phases:
#             preBuild:
#             commands:
#                 - echo "Running NPM clean install"
#                 - npm ci
#             build:
#             commands:
#                 - echo "Building static files...."
#                 - npm run build
#         artifacts:
#             baseDirectory: dist
#             files:
#             - "**/*"
#         cache:
#             paths:
#             - node_modules/**/*
#     EOT

#   access_token = "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"


#   enable_auto_branch_creation = true

#   auto_branch_creation_patterns = [
#     "*",
#     "*/**",
#   ]

#   auto_branch_creation_config {
#     # Enable auto build for the created branch.
#     enable_auto_build = true
#   }


# }


# resource "aws_amplify_branch" "main" {
#   app_id      = aws_amplify_app.frontend.id
#   branch_name = "main"
# }

# # resource "aws_amplify_webhook" "master" {
# #   app_id      = aws_amplify_app.frontend.id
# #   branch_name = aws_amplify_branch.main.branch_name
# #   description = "triggermaster"
# # }


# resource "aws_amplify_app" "test2" {
#   name = "test2"

#   repository = "https://github.com/Varma-PA/csye-frontend"

#   access_token = "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"
# }