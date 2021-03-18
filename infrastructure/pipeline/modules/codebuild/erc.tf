resource "aws_ecr_repository" "ecrepoapp" {
  name                 = "fairfxgroup/${var.application_name}/${var.application_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "keep_15_images" {
  repository = aws_ecr_repository.ecrepoapp.name
  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 15 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 15
     }
   }]
  })
}

