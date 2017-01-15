resource "mailgun_domain" "proxy" {
  name          = "mg.${var.domain}"
  spam_action   = "disabled"
  smtp_password = "${var.smtp_password}"
}

resource "cloudflare_record" "mailgun_recv" {
  count    = "2"
  domain   = "${var.domain}"
  name     = "${var.domain}"
  value    = "${lookup(mailgun_domain.proxy.receiving_records[count.index], "value")}"
  type     = "${lookup(mailgun_domain.proxy.receiving_records[count.index], "record_type")}"
  priority = "${lookup(mailgun_domain.proxy.receiving_records[count.index], "priority")}"
}

resource "cloudflare_record" "mailgun_send" {
  count  = "3"
  domain = "${var.domain}"
  name   = "${lookup(mailgun_domain.proxy.sending_records[count.index], "name")}"
  value  = "${lookup(mailgun_domain.proxy.sending_records[count.index], "value")}"
  type   = "${lookup(mailgun_domain.proxy.sending_records[count.index], "record_type")}"
}
