db-gz-import(){
  zcat $1 | mysql -uroot -proot $2
}
