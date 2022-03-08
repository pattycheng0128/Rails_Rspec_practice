require 'rails_helper'

RSpec.describe CoursesController do
  # index
  describe "GET index" do
    it "assigns @courses" do
      course1 = create(:course)
      course2 = create(:course)

      get :index
      # p "assigns",assigns[:courses]

      expect(assigns[:courses]).to eq([course1, course2])
    end

    it "render template" do
      course1 = create(:course)
      course2 = create(:course)

      get :index

      expect(response).to render_template("index")
    end
  end

  # show
  describe "GET show" do
    it "assigns @course" do
      course = create(:course)

      get :show, params: {id: course.id}

      expect(assigns[:course]).to eq(course)
    end

    it "render template" do
      course = create(:course)

      get :show, params: {id: course.id}

      expect(response).to render_template("show")
    end
  end

  # new
  describe "GET new" do
    it "assign @course" do
      course = build(:course)

      get :new

      expect(assigns(:course)).to be_a_new(Course)
    end

    it "render template" do
      course = build(:course) #產生一個未儲存的 course 對象

      get :new

      expect(response).to render_template("new")
    end
  end

  # create
  describe "POST create" do
    it "create a new course record" do
      course = build(:course)

      expect do
        post :create, params: {:course => attributes_for(:course)}
      end.to change{ Course.count }.by(1)
    end

    it "redirects to courses_path" do
      course = build(:course)

      post :create, params: {:course => attributes_for(:course)}
      expect(response).to redirect_to courses_path
    end

    context "when course doesn't have a title" do
      it "doesn't create a record" do
        expect do
          post :create, params: {course: {:description => "bar"}}
        end.to change {Course.count}.by(0)
      end
  
      it "render new template" do
        post :create, params: {course: {:description => "bar"}}
  
        expect(response).to render_template("new")
      end
    end

    context "when course has title" do
      it "create a new course record" do
        course = build(:course)
  
        expect do
          post :create, params: {course: attributes_for(:course)}
        end.to change {Course.count}.by(1)
      end
  
      it "redirects to courses_path" do
        course = build(:course)
  
        post :create, params:{ course: attributes_for(:course)}
        expect(response).to redirect_to courses_path
      end
    end  
  end

  # edit
  describe "GET edit" do
    it "assign course" do
      course = create(:course)
  
      get :edit , params: {id: course.id}
      expect(response.status).to eq(200)
      expect(assigns[:course]).to eq(course)
    end
  
    it "render template" do
      course = create(:course)
      get :edit , params: {id: course.id}
      expect(response).to render_template("edit")
    end
  end

  # update
  describe "PUT update" do
    context "when course has title" do
      it "assign @course" do
        course = create(:course)

        put :update, params: {id: course.id, course: {title: "test1", description: "hello"}}
        expect(assigns[:course]).to eq(course)
      end

      it "changes value" do
        course = create(:course)

        put :update, params: {id: course.id, course: {title: "test1", description: "hello"}}
        expect(assigns[:course].title).to eq("test1")
        expect(assigns[:course].description).to eq("hello")
      end

      it "redirects to courses_path" do
        course = create(:course)

        put :update, params: {id: course.id, course: {title: "test1", description: "hello"}}
        expect(response).to redirect_to courses_path
      end
    end

    context "when course doesn't have title" do
      it "doesn't update a record" do
        course = create(:course)

        put :update, params: {id: course.id, course:{title: "", description: "hello"}}
        expect(course.description).not_to eq("hello")
      end

      it "render edit template" do
        course = create(:course)

        put :update, params: {id: course.id, course:{title: "", description: "hello"}}
        expect(response).to render_template("edit")
      end
    end
  end
  
  #destroy
  describe "DELETE destroy" do
    it "assign @course" do
      course = create(:course)

      delete :destroy, params:{id: course.id}
      expect(assigns[:course]).to eq(course)
    end

    it "delete a record" do
      course = create(:course)

      expect{delete :destroy, params:{id: course.id}}.to change {Course.count}.by(-1)
    end

    it "redirects to courses_path" do
      course = create(:course)

      delete :destroy, params: {id: course.id}
      expect(response).to redirect_to courses_path
    end
  end
end