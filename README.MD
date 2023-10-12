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
3. ```/schedule/create``` - user sends the schedule and data is broken down and saved in the pad_db and events are created in calendar. Returns: creation status in json
4. ```/schedule/get``` - schedule for specific user is retrieved from the db. Returns: Schedule of user in json
5. ```/schedule/today``` - retrieve the schedule for specific today. Returns: Schedule of user in json
6. ```/schedule/change``` - change the schedule in the db. Returns: change status in json
3. ```/deadlines/create``` - user sends the project deadlines and data is broken down and saved in the pad_db and sent over to notion planner. Returns: creation status in json
4. ```/deadlines/get``` - project deadlines for specific user is retrieved from the db. Returns: Project deadlines of user in json
5. ```/deadlines/week``` - retrieve the project deadlines for specific week. Returns: project deadlines of user in json
6. ```/deadlines/change``` - change the project deadlines in the db and sent over to notion planner. Returns: change status in json

**Notion Planner endpoints**:
1. ```/register``` - create a notion page for the registered user. Returns: creation status in json
2. ```/create_project``` - gets a project data and creates it in the notion page. Returns: creation status in json
3. ```/update_project``` - gets a project data and updates its values (status, name, deadline etc.) Returns: change status in json
4. ```/get_latest``` - retrieves from notion the last changes on projects. Returns: changed project in json
5. ```/get_report``` - retrieves from notion the projects data and sends which ones and what statuses do they have. Returns: project data in json