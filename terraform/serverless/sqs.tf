resource "aws_sqs_queue" "ideation-aws-queue-deadletter" {

  name = "${var.dead_letter_queue}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_sqs_queue" "ideation-aws-queue" {

  name                        = "${var.queue_name[count.index]}"

  visibility_timeout_seconds  = "${var.visibility_timeout_seconds}"
  delay_seconds               = "${var.delay_seconds}"
  max_message_size            = "${var.max_message_size}"
  message_retention_seconds   = "${var.message_retention_seconds}"
  receive_wait_time_seconds   = "${var.receive_wait_time_seconds}"
  redrive_policy              = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.ideation-aws-queue-deadletter.arn}\", \"maxReceiveCount\":4}"
  fifo_queue                  = "${var.fifo_queue}"
  content_based_deduplication = "${var.content_based_deduplication}"

  tags {
    Environment = "${var.environment}"
  }
}

## Event source from SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  
  event_source_arn  = "${aws_sqs_queue.ideation-aws-queue.arn}"
  enabled           = true
  function_name     = "${aws_lambda_function.post-lambda.arn}"
  batch_size        = 1
}