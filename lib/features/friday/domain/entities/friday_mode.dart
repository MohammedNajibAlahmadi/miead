class FridayMode {
  bool isFriday(DateTime date) {
    return date.weekday == DateTime.friday;
  }

  List<String> getFridayChecklist() {
    return [
      'قراءة سورة الكهف',
      'الإكثار من الصلاة على النبي (ﷺ)',
      'صلاة الجمعة في المسجد',
      'ساعة الاستجابة بعد العصر'
    ];
  }
}
