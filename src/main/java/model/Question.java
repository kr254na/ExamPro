package model;

import dao.SubjectDao;
import dto.QuestionDto;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class Question implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int subjectId;
    private String questionText;
    private String optionA, optionB, optionC, optionD;
    private String correctAnswer;
    private int createdBy;

    public Question() {}

    public int getId() { return id; }
    public void setId(int id) {
        this.id = id;
    }

    public int getSubjectId() {
        return subjectId;
    }
    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText;}

    public String getOptionA() { return optionA; }
    public void setOptionA(String optionA) { this.optionA = optionA; }

    public String getOptionB() { return optionB; }
    public void setOptionB(String optionB) { this.optionB = optionB; }

    public String getOptionC() { return optionC; }
    public void setOptionC(String optionC) { this.optionC = optionC; }

    public String getOptionD() { return optionD; }
    public void setOptionD(String optionD) { this.optionD = optionD; }

    public String getCorrectAnswer() { return correctAnswer; }
    public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public static QuestionDto mapQuestionToQuestionDto(Question question){
            QuestionDto questionDto = new QuestionDto();
            questionDto.setQuestionText(question.getQuestionText());
            questionDto.setId(question.getId());
            questionDto.setCorrectAnswer(question.getCorrectAnswer());
            questionDto.setOptionA(question.getOptionA());
            questionDto.setOptionB(question.getOptionB());
            questionDto.setOptionC(question.getOptionC());
            questionDto.setOptionD(question.getOptionD());
            questionDto.setCreatedBy(question.getCreatedBy());
            SubjectDao subjectDao = new SubjectDao();
            questionDto.setSubjectName(subjectDao.getSubjectById(question.getSubjectId())
                    .getSubjectName());
            return questionDto;
    }

    public static List<QuestionDto> mapQuestionsToQuestionDtos(List<Question> questions){
        List<QuestionDto> questionDtos = new ArrayList<>();
        SubjectDao subjectDao = new SubjectDao();
        for(Question question : questions) {
            QuestionDto questionDto = new QuestionDto();
            questionDto.setQuestionText(question.getQuestionText());
            questionDto.setId(question.getId());
            questionDto.setCorrectAnswer(question.getCorrectAnswer());
            questionDto.setOptionA(question.getOptionA());
            questionDto.setOptionB(question.getOptionB());
            questionDto.setOptionC(question.getOptionC());
            questionDto.setOptionD(question.getOptionD());
            questionDto.setCreatedBy(question.getCreatedBy());
            questionDto.setSubjectName(subjectDao.getSubjectById(question.getSubjectId())
                    .getSubjectName());
            questionDtos.add(questionDto);
        }
        return questionDtos;
    }
}