class testing{
  //Property
  String nama = "";

  //constructor
  testing({required this.nama});

  void x(){
    print("Halo saya dipanggil");
  }
}

List anjay = <int>[1,2,3];

void main(){
  testing baru = testing(nama: "rasyid");

  baru.x();

}


