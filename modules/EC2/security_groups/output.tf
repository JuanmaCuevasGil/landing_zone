output "sg_ids" {
  value = {
    public  = aws_security_group.public.id
    private = aws_security_group.private.id
    vpn     = aws_security_group.vpn.id
  }
}
