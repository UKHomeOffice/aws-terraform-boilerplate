resource "aws_api_gateway_deployment" "componentApi-deployment" {
  rest_api_id = aws_api_gateway_rest_api.componentApi.id
  stage_name  = var.environment
  description = "Deploy ComponentApi"
}

resource "aws_api_gateway_rest_api" "componentApi" {
  binary_media_types = [
    "aaa/jpeg",
    "aaa/png",
    "aaa/mp4",
    "aaa/avi",
    "aaa/quicktime",
    "application/octet-stream",
    "multipart/form-data",
  ]
  name = "${var.environment}-component-api"
  body = templatefile("../common/apigateway.json", {
    environment         = local.environment,
    ffprobe_arn         = local.ffprobe_arn,
    gateway_arn         = local.gateway_arn,
    aaa_converter_arn = local.aaa_converter_arn
  })

  endpoint_configuration {
    types = [
      "EDGE",
    ]
  }
}
