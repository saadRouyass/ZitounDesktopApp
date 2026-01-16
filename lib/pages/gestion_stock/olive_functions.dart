
List<String> calculateOliveStock(String oliveType,String barmil){

  final int boites;
  final int carton;
  final int lessieur;
  final double za3tar;
  final int hrissa;
  final int citron;

  switch(oliveType){
    case 'Olive Noire':
      boites = int.parse(barmil) * 360;
      carton = boites%24==0? boites~/24 : boites~/24 + 1; 
      lessieur = int.parse(barmil)*1;
      za3tar =  0;
      hrissa = 0;
      citron = 0;
      return [boites.toString(),carton.toString(),lessieur.toString(),za3tar.toString(),hrissa.toString(),citron.toString()];
      
    case 'Olive Hare':
      boites = int.parse(barmil) * 320;
      carton =  boites%24==0? boites~/24 : boites~/24 + 1;
      lessieur = int.parse(barmil)*2;
      za3tar =  int.parse(barmil)*0.5;
      hrissa = 10*int.parse(barmil);
      citron =0;
      return [boites.toString(),carton.toString(),lessieur.toString(),za3tar.toString(),hrissa.toString(),citron.toString()];
    case 'Olive Mcharmal':
      boites = int.parse(barmil) * 320;
      carton =  boites%24==0? boites~/24 : boites~/24 + 1;
      lessieur = int.parse(barmil)*2;
      za3tar =  int.parse(barmil)*0.5;
      hrissa = 0;
      citron = int.parse(barmil)*10;
      return [boites.toString(),carton.toString(),lessieur.toString(),za3tar.toString(),hrissa.toString(),citron.toString()];
    case 'Olive sans Os':
      boites = int.parse(barmil) * 320;
      carton = boites%24==0? boites~/24 : boites~/24 + 1;
      lessieur = 0;
      za3tar =  0;
      hrissa = 0;
      citron = 0;
      return [boites.toString(),carton.toString(),lessieur.toString(),za3tar.toString(),hrissa.toString(),citron.toString()];
    default:
      return ['0','0','0','0','0','0'];
  }
}