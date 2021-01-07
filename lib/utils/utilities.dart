class Utils{
  static String getInitials(String name){
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    return firstNameInitial;
  }
}