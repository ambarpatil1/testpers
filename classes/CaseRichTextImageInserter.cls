public class CaseRichTextImageInserter {
    public static void createCasesWithImage(Integer startFrom, Integer endAt, String namePrefix) {
        List<Case> casesToInsert = new List<Case>();

        // Safe Base64-encoded JPEG (tiny transparent pixel image)
        String base64Image = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR4nGNgYAAAAAMAASsJTYQAAAAASUVORK5CYII=';

        String imageTag = '<img src="data:image/png;base64,' + base64Image + '" />';

        for (Integer i = startFrom; i <= endAt; i++) {
            Case c = new Case();
            c.Subject = namePrefix + ' ' + i;
            c.RichTextArea__c = 'Embedded image test:<br/>' + imageTag;
            casesToInsert.add(c);
        }

        insert casesToInsert;
    }
}