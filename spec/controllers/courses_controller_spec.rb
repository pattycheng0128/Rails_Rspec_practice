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
    context "when user login" do
      # 在 context 下的 it 都可以使用 let(將重複的code整理到這)
      let(:user) {create(:user)}
      let(:course) {build(:course)} #產生一個未儲存的 course 對象

      # 整理重複的code
      before do
        sign_in user
        get :new
      end

      it "assign @course" do
        expect(assigns(:course)).to be_a_new(Course)
      end

      it "render template" do
        expect(response).to render_template("new")
      end
    end

    context "when user not login" do
      it "redirect_to new_user_session_path" do
        get :new

        expect(response).to redirect_to new_user_session_path
      end
    end
    
  end

  # create
  describe "POST create" do
    let(:user){create(:user)}
    before{sign_in user}

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
  
        post :create, params: { course: attributes_for(:course)}
        expect(response).to redirect_to courses_path
      end

      it "create a course for user" do
        course = build(:course)
        post :create, params: {course: attributes_for(:course)}
        expect(Course.last.user).to eq(user)
      end
    end  
  end

  # edit
  describe "GET edit" do
    # let(:user){create(:user)}
    # before {sign_in user}
    # 必須是建立課程的user才能編輯課程
    let(:author) {create(:user)}
    let(:not_author) {create(:user)}

    context "signed in as author" do
      before {sign_in author}

      it "assigns course" do
        course = create(:course, user: author)
        get :edit, params: {id: course.id}
        expect(assigns[:course]).to eq(course)
      end

      it "render template" do
        course = create(:course, user: author)
        get :edit , params: {id: course.id}
        expect(response).to render_template("edit")
      end
    end

    context "signed in not as author" do
      before {sign_in not_author}

      it "raises an error" do
        course = create(:course, user: author)
        expect do
          get :edit, params: {id: course.id}
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  # update
  describe "PUT update" do
    # let(:user){create(:user)}
    # before{sign_in user}
    let(:author){create(:user)}
    let(:not_author){create(:user)}

    context "sign in as author" do
      before {sign_in author}

      context "when course has title" do
        it "assign @course" do
          course = create(:course, user: author)
  
          put :update, params: {id: course.id, course: {title: "test1", description: "hello"}}
          expect(assigns[:course]).to eq(course)
        end
  
        it "changes value" do
          course = create(:course, user: author)
  
          put :update, params: {id: course.id, course: {title: "test1", description: "hello"}}
          expect(assigns[:course].title).to eq("test1")
          expect(assigns[:course].description).to eq("hello")
        end
  
        it "redirects to courses_path" do
          course = create(:course, user: author)
  
          put :update, params: {id: course.id, course: {title: "test1", description: "hello"}}
          expect(response).to redirect_to courses_path
        end
      end
    
      context "when course doesn't have title" do
        it "doesn't update a record" do
          course = create(:course, user: author)
  
          put :update, params: {id: course.id, course:{title: "", description: "hello"}}
          expect(course.description).not_to eq("hello")
        end
  
        it "render edit template" do
          course = create(:course, user: author)
  
          put :update, params: {id: course.id, course:{title: "", description: "hello"}}
          expect(response).to render_template("edit")
        end
      end
    end

    context "sign in not as author" do
      before{ sign_in not_author}

      it "raises an error" do
        course = create(:course, user: author)

        expect do
          put :update, params: {id: course.id, course:{title:"", description: "hi"}}
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
  
  #destroy
  describe "DELETE destroy" do
    # let(:user){create(:user)}
    # before{sign_in user}
    let(:author){create(:user)}
    let(:not_author){create(:user)}

    context "when sign in as author" do
      before{sign_in author}
      
      it "assign @course" do
        course = create(:course, user: author)

        delete :destroy, params:{id: course.id}
        expect(assigns[:course]).to eq(course)
      end

      it "delete a record" do
        course = create(:course, user: author)
  
        expect{delete :destroy, params:{id: course.id}}.to change {Course.count}.by(-1)
      end

      it "redirects to courses_path" do
        course = create(:course, user: author)
        delete :destroy, params: {id: course.id}

        expect(response).to redirect_to courses_path
      end
    end

    context "when sign in not as author" do
      before{sign_in not_author}

      it "raises an error" do
        course = create(:course, user: author)

        expect do
          delete :destroy, params: {id: course.id}
        end.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end