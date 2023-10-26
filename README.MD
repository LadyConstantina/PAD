## Programarea Aplicatiilor Distribuite
### Student: Constantina Gilca

## Application Suitability
The scope of this product is to help students schedule automatically their lessons in the calendar and their project deadlines in the notion for a better time planning.
Jira is an example of a planning and organisation tool that uses microservices in their backend in order to face the load and function properly.
Notion uses an architecture that resseble microservices, though their development team argues that their use case is very uniques and doesn't entirely fit the term of microservice.

## Service boundaries

**Scheduler** - will take care of user registration, login, schedule creation and creating events in the Calendar.

**Notion Planner** - will take care of creating projects in notion page, setting deadlines, updating and retrieving the current created projects, as well as notifying the user what are the project deadlines for the upcoming week.

## Tech stack and Communication

**Stack** - Elixir (for microservices), python (for cache and gateway), PostgresSql

**Communication** - communication between gateway and microservices will be done using RESTful APIs, and inter-communication between microservices will be done using RPC.

## Data Managment

**Scheduler endpoints**:
1. ```/register``` - user registers and data is saved in the pad_db. Returns: created user data in json
2. ```/login``` - user logs in. Data about the user is retrieved from the pad_db. Returns: user data in json
3. ```/schedule``` - user creates, retrieves schedules from the pad_db. Returns: schedule data in json

**Notion Planner endpoints**:
1. ```/project``` - gets and creates projects with deadlines. Returns: projects in json      
2. ```/notes``` - gets and creates notes for different subjects. Returns: notes in json       
3. ```/exam``` - gets all notes for a particular subject. Returns: notes in json    
