# Rails 501 - Rails 5.2.8.1 with Ruby 2.7.6

## Install Ubuntu Server 20.04 LTS

### Setup Ubuntu

Enable openssh server

```sh
sudo apt install openssh-server
```

Create ssh key for user

```bash
ssh-keygen -t rsa -C user@ubuntu
```

Copy authorized user's key for enable public key authorize

```bash
cd ~/.ssh
cat /tmp/key.pub >> authorized_keys
chmod 600 authorized_keys
```

Setup useful aliases

```sh
vim ~/.bash_aliases
```

```bash
alias update='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias vin='vim +NERDTree'
```

```sh
source ~/.bash_aliases
```

Update Ubuntu

aka `sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y`

```sh
update
```

Install packages for development

```sh
sudo apt install git git-flow vim curl wget gpg w3m -y
```

## Setup development environment

### Setup Environment

Setup UFW for development

```sh
sudo ufw allow from 192.168.0.0/24
sudo ufw enable
```

Config git's global settings

```sh
git config --global user.name user
git config --global user.email user.mail
git config --global core.editor vim
git config --global ui.color true
git config --global init.defaultBranch main
```

Setup Vim and plugins

```sh
git clone git@github.com:alexcode-cc/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone git@github.com:lifepillar/vim-solarized8.git ~/.vim/pack/themes/opt/solarized8
wget https://raw.githubusercontent.com/alexcode-cc/myconfig/main/.vimrc ~/.vimrc
vim +PluginInstall!
```

Setup RVM for ruby management

```sh
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s head --auto-dotfiles
```

Setup gemrc for disable install documents

```sh
vim ~/.gemrc
```

```yml
gem: --no-ri --no-rdoc --no-document
```

Install Ruby 2.7.6

```sh
rvm install 2.7.6 --disable-install-document
ruby -v
```

ruby 2.7.6p219 (2022-04-12 revision c9c2245c0a) [x86_64-linux]

```sh
gem -v
```

`3.1.6`

```sh
gem update --system
gem -v
```

`3.4.11`

```sh
gem -v
```

Install Node 16.9.1

```sh
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash - && sudo apt-get install -y nodejs
sudo npm install -g npm
sudo npm install -g yarn
node -v
```

`v16.19.1`

```sh
npm -v
```

`9.5.1`

```sh
yarn -v
```

`1.22.19`

Create RVM Gemset

```sh
rvm use 2.7.6@rails5281 --create --default --ruby-version
```

Install Rails 5.2.8.1

```sh
gem install rails -v 5.2.8.1
rails -v
```

`Rails 5.2.8.1`

## Setup Rails 501

### Create New Project

Create rails project

```sh
rails new rails501
cp .ruby-gemset rails501/.
cp .ruby-version rails501/.
cd rails501
bundle
rails yarn:install
echo '#!/bin/bash' > run.sh && echo 'rails server -b 0.0.0.0 $@' >> run.sh && chmod u+x run.sh
chmod u+x run.sh
./run.sh
```

Setup changelog

```sh
sudo npm install -g commitizen 
sudo npm install -g cz-conventional-changelog
sudo npm install -g conventional-changelog-cli
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
vim package.json
```

```json
"version": "0.1.0",
"repository": {
  "type": "git",
  "url": "https://github.com/alexcode-cc/Blog501.git"
},
"scripts": {
  "changelog": "conventional-changelog -p angular -i CHANGELOG.md -s",
  "changelog:init": "conventional-changelog -o CHANGELOG.md",
  "changelog:check": "conventional-changelog",
  "changelog:init:angular": "conventional-changelog -p angular -i CHANGELOG.md -s -r 0",
  "changelog:check:angular": "conventional-changelog -p angular",
  "changelog:help": "conventional-changelog --help"
},
```

Git commit

```sh
git add .
git commit -m "Initial commit"
git branch -M main
yarn changelog:check
yarn changelog:init
vim CHANGELOG.md
```

```diff
-## 0.1.0 (2023-04-11)
+# 0.1.0 (2023-04-11)
```

```sh
git add .
git commit -m "docs: add changelog 0.1.0"
git flow init
git switch main
git remote add origin git@github.com:alexcode-cc/Blog601.git
git tag 0.1.0 HEAD -m "initial commit"
git push -u origin --all
git push -u origin --tags
```

### Implement About page

```sh
rails generate controller pages
vim Gemfile
```

```rb
# Use json
gem 'json', '~> 2.3.0'  
```

```sh
vim app/controllers/pages_controller.rb
```

```rb
require 'json'
require 'socket'
class PagesController < ApplicationController
  def index
    @app = Rails.application.class.name.split(/::/)[0]
    @version = JSON.parse(File.read(Rails.root.join('package.json')))['version']
    @rails = Rails.version
    @ruby = RUBY_VERSION
    @env = Rails.env
    @adapter = ActiveRecord::Base.connection.adapter_name
    @host = Socket.gethostname
    @ip = Socket.ip_address_list.find { |ip| ip.ipv4? && !ip.ipv4_loopback? }.ip_address
    @remote_ip = request.remote_ip
    @time = Time.current.to_s(:long)
  end
end
```

```sh
vim app/views/pages/about.html.erb
```

```rb
<div style="display:flex; justify-content: center">
  <table>
    <tbody>
      <tr>
        <td><strong>App Name</strong></td>
        <td><strong><%= @app %></strong></td>
      </tr>
      <tr>
        <td>App Version</td>
        <td><%= @version %></td>
      </tr>
      <tr>
        <td>Rails Version</td>
        <td><%= @rails %></td>
      </tr>
      <tr>
        <td>Ruby Version</td>
        <td><%= @ruby %></td>
      </tr>
      <tr>
        <td>Rails Environment</td>
        <td><%= @env %></td>
      </tr>
      <tr>
        <td>Rails Database</td>
        <td><%= @adapter %></td>
      </tr>
      <tr>
        <td>Host</td>
        <td><%= @host %></td>
      </tr>
      <tr>
        <td>Host IP</td>
        <td><%= @ip %></td>
      </tr>
      <tr>
        <td>Remote IP</td>
        <td><%= @remote_ip %></td>
      </tr>
      <tr>
        <td>Current Time</td>
        <td><%= @time %></td>
      </tr>
    </tbody>
  </table>
</div>
```

```sh
vim config/routes.rb
```

```rb
get 'about', :to => 'pages#about'
root 'pages#about'
```

```sh
./run.sh
vim package.json
```

```json
"version": "0.1.1",
```

```sh
git add .
git cz
```

```txt
choice [feat: A new feature]
add about page
```

```sh
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: update changelog to 0.1.1"
git tag 0.1.1 HEAD -m "add about page"
git push --all && git push --tags
```

### Scaffold Boards Posts

```sh
rails generate scaffold board name
rails generate scaffold post title content:text
rails db:migrate
./run.sh
```

Create Seed

```sh
vim db/seed.rb
```

```rb
begin
  5.times do |i|
    Board.create(name: "board ##{i+1}")
    2.times do |j|
      Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}")
    end
  end
  puts "Seed success!"
rescue
  puts "Seed fail!"
  puts Board.errors if Board.errors.any?
  puts Post.errors if Post.errors.any?
end
```

```sh
rails db:seed
./run.sh
vim package.json
```

Git comment

```json
"version": "0.2.0",
```

```sh
git add .
git commit -m "feat: scaffold board and post"
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: update changelog to 0.2.0"
git tag 0.2.0 HEAD -m "scaffold board and post"
git push --all && git push --tags
```

### Board and Post nested resources

Add has_many and belongs_to for moddels

```sh
vim app/moddels/board.rb
```

```rb
has_many :posts
```

```sh
vim app/moddels/post.rb
```

```rb
belongs_to :board
```

Create mirgation for board id

```sh
rails generate migration add_board_id_to_post board:references
```

```rb
def change
 add_reference :posts, :board, foreign_key: true
end
```

```sh
rails db:migrate
```

Create nested resources for routes

```sh
vim config/routes.rb
```

```rb
resources :boards do
  resources :posts
end
```

Modify seed for board id

```sh
vim db/seed.rb
```

```rb
begin
  5.times do |i|
    Board.create(name: "board ##{i+1}")
    2.times do |j|
      Post.create(title: "title for b#{i+1} p#{j+1}", content: "content for board ##{i+1} post ##{j+1}", board_id: i+1)
    end
  end
  puts "Seed success!"
rescue
  puts "Seed fail!"
  puts Board.errors if Board.errors.any?
  puts Post.errors if Post.errors.any?
end
```

```sh
rails db:reset
```

Modify Board's show action for nested resources

```sh
vim app/controllers/boards_controller.rb
```

```rb
before_action :set_board, only: %i[ show edit update destroy ]
before_action :set_postS, only: %i[ show ]

def set_posts
  @posts = @board.posts
end 
```

```sh
vim app/views/boards/show.html.erb
```

```rb
<% if @posts != nil %>
  <hr>
  <h5>Listing Posts</h5>
  <table>
    <thead>
      <tr>
        <th>Title</th>
        <th>Content</th>
        <th colspan="3"></th>
      </tr>
    </thead>
    <tbody>
    <% @posts.each do |post| %>
      <tr>
        <td><%= post.title %>
        <td><%= post.content %>
        <td><%= link_to 'Show', board_post_path(@board, post) %></td>
        <td><%= link_to 'Edit', edit_board_post_path(@board, post) %></td>
        <td><%= link_to 'Destroy', board_post_path(@board, post), method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
    </tbody>
  </table>
  <hr>
<% end %>
<br>
<%= link_to 'New Post', new_board_post_path(@board) %> |
<%= link_to 'Edit', edit_board_path(@board) %> |
<%= link_to 'Back', boards_path %>
```

Modify Post's index/show action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
before_action :set_board
before_action :set_post, only: %i[ show edit update destroy ] 

def index                                                                             
  redirect_to board_path(@board)
end

def set_board
  @board = Board.find(params[:board_id])
end 

def set_post
  @post = @board.posts.find(params[:id])
end 
```

```sh
rm app/views/posts/index.*
vim app/views/posts/show.html.erb
```

```rb
<%= link_to 'Edit', edit_board_post_path(@board,@post) %> |
<%= link_to 'Back', board_posts_path(@board) %>
```

Modify Post's new action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
def new
  @post = @board.posts.build                                                    
end 

def create
  @post = @board.posts.build(post_params)

  respond_to do |format|
    if @post.save
      format.html { redirect_to board_post_path(@board, @post), notice: "Post was successfully created." }           
      format.json { render :show, status: :created, location: @post }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end 
  end 
end 
```

```sh
vim app/views/posts/new.html.erb
```

```rb
<%= form_with(model: @post, local: true, :url => board_posts_path(@board)) do |f| %>
  <%= render 'form', form: f %>
<% end %>

<%= link_to 'Back', board_posts_path(@board) %>
```

```sh
vim app/views/posts/_form.html.erb
```

```rb
<% if @post.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(@post.errors.count, "error") %> prohibited this post from being saved:</h2>
    <ul>
    <% @post.errors.full_messages.each do |message| %>
      <li><%= message %></li>
    <% end %>
    </ul>
  </div>
<% end %>
```

Modify Post's update action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
def update
  respond_to do |format|
    if @post.update(post_params)
      format.html { redirect_to board_post_path(@board, @post), notice: "Post was successfully updated." }
      format.json { render :show, status: :ok, location: @post }                                                     
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @post.errors, status: :unprocessable_entity }
    end 
  end 
end 
```

```sh
vim app/views/posts/edit.html.erb
```

```rb
<%= form_with(model: @post, local: true, :url => board_post_path(@board, @post)) do |f| %>
  <%= render 'form', form: f %>
<% end %>

<%= link_to 'Show', board_post_path(@board, @post) %> |
<%= link_to 'Back', board_posts_path(@board) %>
```

Modify Post's destroy action for nested resources

```sh
vim app/controllers/posts_controller.rb
```

```rb
def destroy                                                                                                          
  @post.destroy

  respond_to do |format|
    format.html { redirect_to board_posts_path(@board), notice: "Post was successfully destroyed." }
    format.json { head :no_content }
  end 
end 
```

Git comment

```json
"version": "0.3.0",
```

```sh
git add .
git commit -m "feat: modify codes for nested resources"
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: update changelog to 0.3.0"
git tag 0.3.0 HEAD -m "modify codes for nested resources"
git push --all && git push --tags
```

### Use devise for user management

Setup devise

```sh
vim Gemfile
```

```rb
# Use devise for user management
gem 'devise', '~> 4.9.2'
```

```sh
bundle install
rails generate devise:install
vim config/environments/development.rb
```

```rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

```sh
vim app/views/layouts/application.html.erb
```

```rb
<p class="notice" id="notice" style="color:green;"><%= notice %></p>
<p class="alert" id="alert" style="color:red;"><%= alert %></p>
```

```sh
rails generate devise:views
rails generate devise user
rails db:migrate
vim app/controllers/boards_controller.rb
```

```rb
before_action :authenticate_user!, only: %i[ new ]
```

```sh
vim app/controllers/posts_controller.rb
```

```rb
before_action :authenticate_user!, only: %i[ new ]
```

Add user navigation bar

```sh
vim app/views/pages/about.html.erb
```

```rb
<%= link_to 'Boards', boards_path %>
```

```sh
vim app/views/boards/index.html.erb
```

```rb
| <%= link_to 'Home', root_path %>
```

```sh
mkdir app/views/shared
vim app/views/shared/_user_nav.html.erb
```

```rb
<div class="user_navigation">
  <% if !current_user %>
    <%= link_to 'Sign in', new_user_session_path %>
    <%= link_to 'Sign up', new_user_registration_path %>
  <% else %>
    Hi! <%= current_user.email %>
    <%= link_to 'Sign out', destroy_user_session_path, :method => :delete %>
  <% end %>
</div>
```

```sh
vim vim app/views/layouts/application.html.erb
```

```rb
<%= render 'shared/user_nav' %>
```

Add name to user model

```sh
rails generate migration add_username_to_user username:string:index
```

```rb
class AddNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string, null: false, default: ""
    add_index :users, :username, unique: true
  end

end
```

```sh
rails db:migrate
vim app/views/devise/regaistrations/new.html.erb
```

```rb
<div class="field">
  <%= f.label 'name' %><br />
  <%= f.text_field :username, autofocus: true %>
</div>  
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>  
```

```sh
vim app/views/devise/regaistrations/edit.html.erb
```

```rb
<div class="field">
  <%= f.label 'name' %><br/>
  <%= f.text_field :username, autofocus: true %><br/>
</div>  
<div class="field">
  <%= f.label :email %><br />
  <%= f.email_field :email, autofocus: true, autocomplete: "email" %>
</div>  
```

```sh
vim app/views/shared/_user_nav.html.erb
```

```rb
    Hi! <%= current_user.username %>
```

```sh
vim app/controllers/application_controller.rb
```

```rb
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
```

Add user id to board

```sh
rails generate migration add_user_id_to_board user:references
```

```rb
def change
 add_reference :boards, :user, foreign_key: true
end
```

```sh
vim app/models/board.rb
```

```rb
belongs_to :user
```

```sh
vim app/models/user.rb
```

```rb
has_many :boards
```

```sh
rails db:migrate
```

## Modify boards controller / views for User

```sh
vim app/controllers/boards_controller.rb
```

```rb
before_action :authenticate_user! , only: %i[ new create ]

def create
  @board = Board.new(board_params)
  @board.user = current_user

  respond_to do |format|
    if @board.save
      format.html { redirect_to board_url(@board), notice: "Board was successfully created." }
      format.json { render :show, status: :created, location: @board }
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @board.errors, status: :unprocessable_entity }
    end
  end
end
```

```sh
vim app/views/boards/index.html.erb
```

```rb
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Creator</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody>
    <% @boards.each do |board| %>
      <tr>
        <td><%= board.name %></td>
        <td><%= board.user.username %></td>
        <td><%= link_to 'Show', board %></td>
        <td><%= link_to 'Edit', edit_board_path(board) %></td>
        <td><%= link_to 'Destroy', board, method: :delete, data: { confirm: 'Are you sure?' } %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

Modify seed for create default user

```sh
vim db/seed.rb
```

```rb
begin
  user = User.create! :username => 'admin', :email => 'admin@rails501.org', :password => 'P@ssw0rd', :password_confirmation => 'P@ssw0rd'
  5.times do |i|
    Board.create(name: "Board ##{i+1}", user_id: 1)
    2.times do |j|
      Post.create(title: "Title for b#{i+1} p#{j+1}", content: "Content for board ##{i+1} post ##{j+1}", board_id: i+1)
    end
  end
  puts "Seed success!"
rescue
  puts "Seed fail!"
  puts Board.errors if Board.errors.any?
  puts Post.errors if Post.errors.any?
end   
```

```sh
rails db:reset
```

Only board owner can edit/delete board and post

```sh
vim app/controllers/boards_controller.rb
```

```rb
before_action :set_posts, only: %i[ show ]
before_action :authenticate_user! , only: %i[ new create edit update destroy ]
before_action :check_user_permission , only: %i[ edit update destroy ]

def check_user_permission
  if current_user != @board.user
    redirect_to boards_path, alert: "#{current_user.username}, You are no permission to update/delete #{@board.name}."
  end
end
```

```sh
vim app/controllers/posts_controller.rb
```

```rb
before_action :set_board
before_action :set_post, only: %i[ show edit update destroy ]
before_action :authenticate_user!, except: [:show]
before_action :check_user_permission, only: %i[ new create edit update destroy ]

def check_user_permission
  if current_user != @board.user
    redirect_to board_path(@board), alert: "#{current_user.username}, You are no permission to create/update/delete  #{@post.title}."
  end
end
```

Git comment

```json
"version": "0.4.0",
```

```sh
git add .
git commit -m "feat: use devise for user management"
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: update changelog to 0.4.0"
git tag 0.4.0 HEAD -m "use devise for user management"
git push --all && git push --tags
```

### Use Bootstrap for UI

Setup bootstrap 5

```sh
#yarn add bootstrap jquery popper.js @popperjs/core
yarn add bootstrap@5.2.3 jquery@3.6.4 popper.js@1.16.1 @popperjs/core@2.11.7
```

```sh
vim app/assets/javascript/application.js
```

```rb
//= require jquery
//= require bootstrap/dist/js/bootstrap.bundle.js
//= require_tree .
```

```sh
vim app/assets/stylesheets/bootstrap.scss
```

```scss
@import "bootstrap/scss/bootstrap";

.alert-notice {
  @extend .alert-info;
}

.alert-alert {
  @extend .alert-danger;
}

.nav-logo {
    background: #D30001;
    border-radius: 100%;
    height: 43px;
    left: 8px;
    position: absolute;
    top: 6px;
    transition: background 0.25s cubic-bezier(0.33, 1, 0.68, 1);
    width: 43px;
    z-index: 2;
}

.nav-logo:after {
    background-image: url(images/logo.svg);
    background-position: left center;
    background-repeat: no-repeat;
    background-size: 100% 100%;
    content: '';
    filter: brightness(0) invert(1);
    height: 24px;
    left: 4px;
    position: absolute;
    top: 7px;
    width: 33px;
}

.nav-logo:hover {
    background: #261B23;
}

```

```sh
mkdir app/views/shared
mkdir public/images
vim app/views/shared/_flash.html.erb
```

```rb
<% flash.each do |msg_type, msg| %>
  <div class="alert alert-<%= msg_type %> alert-dismissible fade show" role="alert">
    <%= msg %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="x"></button>
  </div>
<% end %>
```

```sh
vim app/views/shared/_footer.html.erb
```

```rb
<footer class="container" style="margin-top: 40px;">
  <p class="text-center">Copyright ©2023 Rails501</p>
</footer>
```

```sh
vim app/views/layout/application.html.erb
```

```rb
<div class="container">
  <%= render 'shared/navbar' %>
  <%= yield %>
  <%= render 'shared/footer' %>
  <%= render 'shared/flash' %>
</div>
```

```sh
vim app/controllers/pages_controller.rb
```

```rb
def about
  ...
  flash[:alert] = 'Hello Alert!'
  flash[:info] = 'Hello Info!'
  flash[:warning] = 'Hello Warning!'
  flash[:success] = 'Hello Success!'
end
```

```sh
vim public/images/logo.svg
```

```html
<svg height="32" viewBox="0 0 90 32" width="90" xmlns="http://www.w3.org/2000/svg"><path d="m418.082357 25.9995403v4.1135034h-7.300339v1.89854h3.684072c1.972509 0 4.072534 1.4664311 4.197997 3.9665124l.005913.2373977v1.5821167c-.087824 3.007959-2.543121 4.1390018-4.071539 4.2011773l-.132371.0027328h-7.390745v-4.0909018l7.481152-.0226016v-1.9889467l-1.190107.0007441-.346911.0008254-.084566.0003251-.127643.0007097-.044785.0003793-.055764.0007949-.016378.0008259c.000518.0004173.013246.0008384.034343.0012518l.052212.000813c.030547.0003979.066903.0007803.105225.0011355l.078131.0006709-.155385-.0004701c-.31438-.001557-.85249-.0041098-1.729029-.0080055-1.775258 0-4.081832-1.3389153-4.219994-3.9549201l-.006518-.24899v-1.423905c0-2.6982402 2.278213-4.182853 4.065464-4.2678491l.161048-.003866zm-18.691579 0v11.8658752h6.170255v4.1361051h-10.735792v-16.0019803zm-6.441475 0v16.0019803h-4.588139v-16.0019803zm-10.803597 0c1.057758 0 4.04923.7305141 4.198142 3.951222l.005768.2526881v11.7980702h-4.271715v-2.8252084h-4.136105v2.8252084h-4.407325v-11.7980702c0-1.3184306 1.004082-4.0468495 3.946899-4.197411l.257011-.0064991zm-24.147177-.0027581 8.580186.0005749c.179372.0196801 4.753355.5702841 4.753355 5.5438436s-3.775694 5.3947112-3.92376 5.4093147l-.004472.0004216 5.00569 5.0505836h-6.374959l-3.726209-3.8608906v3.8608906h-4.309831zm22.418634-2.6971669.033418.0329283s-.384228.27122-.791058.610245c-12.837747-9.4927002-20.680526-5.0175701-23.144107-3.8196818-11.187826 6.2428065-7.954768 21.5678895-7.888988 21.8737669l.001006.0046469h-17.855317s.67805-6.6900935 5.4244-14.600677c4.74635-7.9105834 12.837747-13.9000252 19.414832-14.4876686 12.681632-1.2703535 24.110975 9.7062594 24.805814 10.3864403zm-31.111679 14.1815719 2.44098.881465c.113008.8852319.273103 1.7233771.441046 2.4882761l.101394.4499406-2.7122-.9718717c-.113009-.67805-.226017-1.6499217-.27122-2.84781zm31.506724-7.6619652h-1.514312c-1.128029 0-1.333125.5900716-1.370415.8046431l-.007251.056292-.000906.0152319-.00013 3.9153864h4.136105l-.000316-3.916479c-.004939-.0795522-.08331-.8750744-1.242775-.8750744zm-50.492125.339025 2.599192.94927c-.316423.731729-.719369 1.6711108-1.011998 2.4093289l-.118085.3028712-2.599192-.94927c.226017-.610245.700652-1.7403284 1.130083-2.7122001zm35.445121-.1434449h-3.456844v3.6588673h3.434397s.98767-.3815997.98767-1.8406572-.965223-1.8182101-.965223-1.8182101zm-15.442645-.7606218 1.62732 1.2882951c-.180814.705172-.318232 1.410344-.412255 2.115516l-.06238.528879-1.830735-1.4465067c.180813-.81366.384228-1.6499217.67805-2.4861834zm4.000495-6.3058651 1.017075 1.5369134c-.39779.4158707-.766649.8317413-1.095006 1.2707561l-.238493.3339623-1.08488-1.6273201c.40683-.5198383.881465-1.0396767 1.401304-1.5143117zm-16.182794-3.3450467 1.604719 1.4013034c-.40683.4237812-.800947.8729894-1.172815 1.3285542l-.364099.4569775-1.740328-1.4917101c.519838-.5650416 1.08488-1.1300833 1.672523-1.695125zm22.398252-.0904067.497237 1.4917101c-.524359.162732-1.048717.3688592-1.573076.6068095l-.393269.1842488-.519838-1.559515c.565041-.2486184 1.22049-.4972367 1.988946-.7232534zm5.28879-.54244c.578603.0361627 1.171671.1012555 1.779204.2068505l.458361.0869712-.090406 1.4013034c-.596684-.1265694-1.193368-.2097435-1.790052-.2495224l-.447513-.0216976zm-18.555968-6.2380601 1.017075 1.559515c-.440733.2203663-.868752.4661594-1.303128.7278443l-.437201.2666291-1.039676-1.5821167c.610245-.3616267 1.197888-.67805 1.76293-.9718717zm18.601172-.8588633c1.344799.3842283 1.923513.6474959 2.155025.7707625l.037336.0202958-.090406 1.5143117c-.482169-.1958811-.964338-.381717-1.453204-.5575078l-.739158-.2561522zm-8.633837-1.3334984.452033 1.3787017h-.226016c-.491587 0-.983173.0127134-1.474759.0476754l-.491587.0427313-.429431-1.3334984c.745855-.0904067 1.469108-.13561 2.16976-.13561z" transform="translate(-329 -10)"/></svg>
```

```sh
vim app/views/shared/_navbar.html.erb
```

```rb
<nav class='navbar navbar-light bg-light navbar-expand-lg'>
  <div class='container-fluid'>
    <a class="nav-logo" href="https://rubyonrails.org/" target="_blank" aria-label="Ruby on Rails"></a>
    <%= link_to 'Rails 501', root_path, class: 'navbar-brand ms-5 mb-0 h1 btn btn-outline-danger' %>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class='collapse navbar-collapse' id="navbarSupportedContent">
      <ul class='navbar-nav ms-auto mb-2 mb-lg-0'>
        <li class="nav-item">
          <%= link_to 'About', '/about', class: 'nav-link' %>
        </li>
        <li class="nav-item">
        </li>
      <% if !current_user %>
        <li class="dropdown">
          <button class="btn btn-sm btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
           Login  
          </button>
          <ul class="dropdown-menu">
            <li> <%= link_to 'Login', new_user_session_path, class: "dropdown-item" %></li>
            <li> <%= link_to 'Register', new_user_registration_path, class: "dropdown-item" %> </li>
          </ul>
        </li>
      <% else %>
        <li class="dropdown">
          <button class="btn btn-sm btn-light dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
            <%= current_user.username %>
          </button>
          <ul class="dropdown-menu">
            <li><%= link_to 'Edit', edit_user_registration_path, class: 'dropdown-item' %></li>
            <li><%= link_to 'Logout', destroy_user_session_path, :method => :delete, class: "dropdown-item" %></li>
          </ul>
        </li>
      <% end %>
      </ul>
    </div>
  </div>
</nav>
<div class="card border-white" style="height: 2rem;">
</div>
```

Git comment

```json
"version": "0.5.0",
```

```sh
git add .
git commit -m "feat: use bootstrap 5 for ui"
yarn changelog:check
yarn changelog
git add .
git commit -m "docs: update changelog to 0.5.0"
git tag 0.5.0 HEAD -m "use bootstrap 5 for ui"
git push --all && git push --tags
```
