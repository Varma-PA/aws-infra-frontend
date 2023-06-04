resource "aws_codepipeline" "Code_Pipeline" {

  # Very important to mention depends on and making sure iam role has been created first
  depends_on = [aws_codebuild_project.build_react_project, aws_iam_role.codepipeline_role]

  name = "Terraform_test_codepipeline"

  artifact_store {
    location = aws_s3_bucket.frontend_bucket.bucket
    type     = "S3"
  }

  role_arn = aws_iam_role.codepipeline_role.arn

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        # ConnectionArn    = aws_codestarconnections_connection.github_access.arn
        ConnectionArn    = "arn:aws:codestar-connections:us-east-1:141894463187:connection/2957a2a0-1b9f-420e-8c8c-361c1aac2763"
        FullRepositoryId = "Varma-PA/csye-frontend"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "react_build_project"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = "dev.achyuthvarma.me"
        Extract    = "true"
      }
    }
  }


}

# resource "aws_codestarconnections_connection" "github_access" {
#   name          = "Github_Access"
#   provider_type = "GitHub"
# }

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.frontend_bucket.arn,
      "${aws_s3_bucket.frontend_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "GithubConnections"
    effect = "Allow"
    actions = [
      "codestar-connections:UseConnection",
      "codestar-connections:GetConnection"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "logs:*",
    ]

    resources = ["*"]
  }



}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}