/* User Table Creation and Cleanup */
/* Code block to create clean copy of the default user table without fake or deleted users */

CREATE TABLE clean_users
SELECT * FROM users
WHERE users.fake = 0
AND users.deleted = 0;
CREATE INDEX id ON clean_users(id);

/* Code blocks to create tables of users from Russia, China, the United States, India based on their country_code properties of ru, cn, us, or in respectively */

CREATE TABLE russian_users
SELECT * FROM clean_users
WHERE country_code = 'ru';
CREATE INDEX id ON russian_users(id);

CREATE TABLE chinese_users
SELECT * FROM clean_users
WHERE country_code = 'cn';
CREATE INDEX id ON chinese_users(id);

CREATE TABLE unitedstates_users
SELECT * FROM clean_users
WHERE country_code = 'us';
CREATE INDEX id ON unitedstates_users(id);

CREATE TABLE indian_users
SELECT * FROM clean_users
WHERE country_code = 'in';
CREATE INDEX id ON indian_users(id);
/* User Follower Counts */
/* Code blocks to create follower count tables that include followers for each user from any 
source, for all users and for each of the selected countries. */ 

CREATE TABLE clean_users_followers_count
SELECT followers.user_id, COUNT(*) AS follower_count, clean_users.login 
FROM followers, clean_users
WHERE clean_users.id = followers.user_id 
GROUP BY clean_users.id, clean_users.login;
CREATE INDEX user_id ON clean_users_followers_count(user_id);

CREATE TABLE russian_followers
SELECT followers.* 
FROM followers, russian_users
WHERE russian_users.id = followers.user_id;
CREATE INDEX user_id ON russian_followers(user_id);
CREATE INDEX follower_id ON russian_followers(follower_id);

CREATE TABLE russian_followers_count
SELECT russian_followers.user_id, COUNT(*) AS follower_count, russian_users.login 
FROM russian_followers, russian_users
WHERE russian_users.id = russian_followers.user_id 
GROUP BY russian_users.id, russian_users.login;
CREATE INDEX user_id ON russian_followers_count(user_id);

CREATE TABLE chinese_followers
SELECT followers.* 
FROM followers, chinese_users
WHERE chinese_users.id = followers.user_id;
CREATE INDEX user_id ON chinese_followers(user_id);
CREATE INDEX follower_id ON chinese_followers(follower_id);

CREATE TABLE chinese_followers_count
SELECT chinese_followers.user_id, COUNT(*) AS follower_count, chinese_users.login 
FROM chinese_followers, chinese_users
WHERE chinese_users.id = chinese_followers.user_id 
GROUP BY chinese_users.id, chinese_users.login;
CREATE INDEX user_id ON chinese_followers_count(user_id);


CREATE TABLE unitedstates_followers
SELECT followers.* 
FROM followers, unitedstates_users
WHERE unitedstates_users.id = followers.user_id;
CREATE INDEX user_id ON unitedstates_followers(user_id);
CREATE INDEX follower_id ON unitedstates_followers(follower_id);

CREATE TABLE unitedstates_followers_count
SELECT unitedstates_followers.user_id, COUNT(*) AS follower_count, unitedstates_users.login 
FROM unitedstates_followers, unitedstates_users
WHERE unitedstates_users.id = unitedstates_followers.user_id 
GROUP BY unitedstates_users.id, unitedstates_users.login;
CREATE INDEX user_id ON unitedstates_followers_count(user_id);

CREATE TABLE indian_followers
SELECT followers.* 
FROM followers, indian_users
WHERE indian_users.id = followers.user_id;
CREATE INDEX user_id ON indian_followers(user_id);
CREATE INDEX follower_id ON indian_followers(follower_id);

CREATE TABLE indian_followers_count
SELECT indian_followers.user_id, COUNT(*) AS follower_count, indian_users.login 
FROM indian_followers, indian_users
WHERE indian_users.id = indian_followers.user_id 
GROUP BY indian_users.id, indian_users.login;
CREATE INDEX user_id ON indian_followers_count(user_id);

/* Code blocks to create follower count tables that only include followers for each user that are identified to be within that user’s nation. */

CREATE TABLE russian_to_russian_follower_count
SELECT a.user_id, COUNT(*) AS follower_count
FROM russian_followers a, russian_users b
WHERE a.follower_id = b.id
GROUP BY a.user_id;
CREATE INDEX user_id ON russian_to_russian_follower_count(user_id);
ALTER TABLE russian_to_russian_follower_count
ADD(login VARCHAR(255));
UPDATE russian_to_russian_follower_count
SET login = (SELECT login FROM russian_users WHERE russian_to_russian_follower_count.user_id = russian_users.id);

CREATE TABLE chinese_to_chinese_follower_count
SELECT a.user_id, COUNT(*) AS follower_count
FROM chinese_followers a, chinese_users b
WHERE a.follower_id = b.id
GROUP BY a.user_id;
CREATE INDEX user_id ON chinese_to_chinese_follower_count(user_id);
ALTER TABLE chinese_to_chinese_follower_count
ADD(login VARCHAR(255));
UPDATE chinese_to_chinese_follower_count
SET login = (SELECT login FROM chinese_users WHERE chinese_to_chinese_follower_count.user_id = chinese_users.id);

CREATE TABLE unitedstates_to_unitedstates_follower_count
SELECT a.user_id, COUNT(*) AS follower_count
FROM unitedstates_followers a, unitedstates_users b
WHERE a.follower_id = b.id
GROUP BY a.user_id;
CREATE INDEX user_id ON unitedstates_to_unitedstates_follower_count(user_id);
ALTER TABLE unitedstates_to_unitedstates_follower_count
ADD(login VARCHAR(255));
UPDATE unitedstates_to_unitedstates_follower_count
SET login = (SELECT login FROM unitedstates_users WHERE unitedstates_to_unitedstates_follower_count.user_id = unitedstates_users.id);

CREATE TABLE indian_to_indian_follower_count
SELECT a.user_id, COUNT(*) AS follower_count
FROM indian_followers a, indian_users b
WHERE a.follower_id = b.id
GROUP BY a.user_id;
CREATE INDEX user_id ON indian_to_indian_follower_count(user_id);
ALTER TABLE indian_to_indian_follower_count
ADD(login VARCHAR(255));
UPDATE indian_to_indian_follower_count
SET login = (SELECT login FROM indian_users WHERE indian_to_indian_follower_count.user_id = indian_users.id);
/* Repository Table Creation */
/* Code blocks to create separate tables for each selected country containing the repositories owned by the users from that country. These tables are required to create the following national fork and watcher counts and are used later to create the fork counts for influence analysis of repositories owned by users from each nation. */

CREATE TABLE russian_projects
SELECT russian_users.login, projects.*
FROM russian_users, projects
WHERE russian_users.id = projects.owner_id;
CREATE INDEX id ON russian_projects(id);
CREATE INDEX owner_id ON russian_projects(owner_id);
CREATE INDEX forked_from ON russian_projects(forked_from);

CREATE TABLE chinese_projects
SELECT chinese_users.login, projects.*
FROM chinese_users, projects
WHERE chinese_users.id = projects.owner_id;
CREATE INDEX id ON chinese_projects(id);
CREATE INDEX owner_id ON chinese_projects(owner_id);
CREATE INDEX forked_from ON chinese_projects(forked_from);

CREATE TABLE unitedstates_projects
SELECT unitedstates_users.login, projects.*
FROM unitedstates_users, projects
WHERE unitedstates_users.id = projects.owner_id;
CREATE INDEX id ON unitedstates_projects(id);
CREATE INDEX owner_id ON unitedstates_projects(owner_id);
CREATE INDEX forked_from ON unitedstates_projects(forked_from);

CREATE TABLE indian_projects
SELECT indian_users.login, projects.*
FROM indian_users, projects
WHERE indian_users.id = projects.owner_id;
CREATE INDEX id ON indian_projects(id);
CREATE INDEX owner_id ON indian_projects(owner_id);
CREATE INDEX forked_from ON indian_projects(forked_from);
/* User Fork Counts */
/* Code blocks to create fork count tables that include followers for each repository from any 
source, for all repositories and for each of the selected countries owned repositories. */

CREATE TABLE project_fork_count
SELECT a.id, COUNT(*) AS fork_count, a.owner_id
FROM projects a, projects b
WHERE a.id = b.forked_from 
GROUP BY a.id, a.owner_id;
CREATE INDEX id ON project_fork_count(id);
CREATE INDEX owner_id ON project_fork_count(owner_id);

CREATE TABLE russian_project_fork_count
SELECT russian_projects.id, COUNT(*) AS fork_count, russian_projects.owner_id
FROM russian_projects, projects
WHERE russian_projects.id = projects.forked_from
GROUP BY russian_projects.id, russian_projects.owner_id;
CREATE INDEX id ON russian_project_fork_count(id);
CREATE INDEX owner_id ON russian_project_fork_count(owner_id);

CREATE TABLE chinese_project_fork_count
SELECT chinese_projects.id, COUNT(*) AS fork_count, chinese_projects.owner_id
FROM chinese_projects, projects
WHERE chinese_projects.id = projects.forked_from
GROUP BY chinese_projects.id, chinese_projects.owner_id;
CREATE INDEX id ON chinese_project_fork_count(id);
CREATE INDEX owner_id ON chinese_project_fork_count(owner_id);

CREATE TABLE unitedstates_project_fork_count
SELECT unitedstates_projects.id, COUNT(*) AS fork_count, unitedstates_projects.owner_id
FROM unitedstates_projects, projects
WHERE unitedstates_projects.id = projects.forked_from
GROUP BY unitedstates_projects.id, unitedstates_projects.owner_id;
CREATE INDEX id ON unitedstates_project_fork_count(id);
CREATE INDEX owner_id ON unitedstates_project_fork_count(owner_id);

CREATE TABLE indian_project_fork_count
SELECT indian_projects.id, COUNT(*) AS fork_count, indian_projects.owner_id
FROM indian_projects, projects
WHERE indian_projects.id = projects.forked_from
GROUP BY indian_projects.id, indian_projects.owner_id;
CREATE INDEX id ON indian_project_fork_count(id);
CREATE INDEX owner_id ON indian_project_fork_count(owner_id);

/* Code blocks to create fork count tables that only include forks for each repository that are identified to have been forked by a user from within the original repository owner’s nation. */

CREATE TABLE russian_to_russian_project_fork_count
SELECT a.id, COUNT(*) AS fork_count, a.owner_id
FROM russian_projects a, russian_projects b
WHERE a.id = b.forked_from 
GROUP BY a.id, a.owner_id;
CREATE INDEX id ON russian_to_russian_project_fork_count(id);
CREATE INDEX owner_id ON russian_to_russian_project_fork_count(owner_id);

CREATE TABLE chinese_to_chinese_project_fork_count
SELECT a.id, COUNT(*) AS fork_count, a.owner_id
FROM chinese_projects a, chinese_projects b
WHERE a.id = b.forked_from 
GROUP BY a.id, a.owner_id;
CREATE INDEX id ON chinese_to_chinese_project_fork_count(id);
CREATE INDEX owner_id ON chinese_to_chinese_project_fork_count(owner_id);

CREATE TABLE unitedstates_to_unitedstates_project_fork_count
SELECT a.id, COUNT(*) AS fork_count, a.owner_id
FROM unitedstates_projects a, unitedstates_projects b
WHERE a.id = b.forked_from 
GROUP BY a.id, a.owner_id;
CREATE INDEX id ON unitedstates_to_unitedstates_project_fork_count(id);
CREATE INDEX owner_id ON unitedstates_to_unitedstates_project_fork_count(owner_id);

CREATE TABLE indian_to_indian_project_fork_count
SELECT a.id, COUNT(*) AS fork_count, a.owner_id
FROM indian_projects a, indian_projects b
WHERE a.id = b.forked_from 
GROUP BY a.id, a.owner_id;
CREATE INDEX id ON indian_to_indian_project_fork_count(id);
CREATE INDEX owner_id ON indian_to_indian_project_fork_count(owner_id);
/* User Watcher (Star) Counts */
/* Code blocks to create watcher (star) count tables that include watchers for each repository from any source, for all repositories and for each of the selected countries owned repositories. */

CREATE TABLE project_watcher_count
SELECT projects.id, COUNT(*) AS watcher_count, projects.owner_id
FROM projects, watchers
WHERE projects.id = watchers.repo_id 
GROUP BY projects.id, projects.owner_id;
CREATE INDEX id ON project_watcher_count(id);
CREATE INDEX owner_id ON project_watcher_count(owner_id);

CREATE TABLE russian_project_watcher_count
SELECT russian_projects.id, COUNT(*) AS watcher_count, russian_projects.owner_id
FROM russian_projects, watchers
WHERE russian_projects.id = watchers.repo_id
GROUP BY russian_projects.id, russian_projects.owner_id;
CREATE INDEX id ON russian_project_watcher_count(id);
CREATE INDEX owner_id ON russian_project_watcher_count(owner_id);

CREATE TABLE chinese_project_watcher_count
SELECT chinese_projects.id, COUNT(*) AS watcher_count, chinese_projects.owner_id
FROM chinese_projects, watchers
WHERE chinese_projects.id = watchers.repo_id
GROUP BY chinese_projects.id, chinese_projects.owner_id;
CREATE INDEX id ON chinese_project_watcher_count(id);
CREATE INDEX owner_id ON chinese_project_watcher_count(owner_id);

CREATE TABLE unitedstates_project_watcher_count
SELECT unitedstates_projects.id, COUNT(*) AS watcher_count, unitedstates_projects.owner_id
FROM unitedstates_projects, watchers
WHERE unitedstates_projects.id = watchers.repo_id
GROUP BY unitedstates_projects.id, unitedstates_projects.owner_id;
CREATE INDEX id ON unitedstates_project_watcher_count(id);
CREATE INDEX owner_id ON unitedstates_project_watcher_count(owner_id);

CREATE TABLE indian_project_watcher_count
SELECT indian_projects.id, COUNT(*) AS watcher_count, indian_projects.owner_id
FROM indian_projects, watchers
WHERE indian_projects.id = watchers.repo_id
GROUP BY indian_projects.id, indian_projects.owner_id;
CREATE INDEX id ON indian_project_watcher_count(id);
CREATE INDEX owner_id ON indian_project_watcher_count(owner_id);

/* Code blocks to create watcher (star) count tables that only include watchers for each repository that are identified to have been starred by a user from within the original repository owner’s nation. To do this, a truncated watchers table is created first for each country, which is then used for the subsequent watcher count query. */

CREATE TABLE russian_watchers
SELECT watchers.* 
FROM watchers, russian_users
WHERE watchers.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers(repo_id);
CREATE INDEX user_id ON russian_watchers(user_id);

CREATE TABLE russian_to_russian_project_watcher_count
SELECT russian_projects.id, COUNT(*) AS watcher_count, russian_projects.owner_id
FROM russian_projects, russian_watchers
WHERE russian_projects.id = russian_watchers.repo_id
GROUP BY russian_projects.id, russian_projects.owner_id;
CREATE INDEX id ON russian_to_russian_project_watcher_count(id);
CREATE INDEX owner_id ON russian_to_russian_project_watcher_count(owner_id);

CREATE TABLE chinese_watchers
SELECT watchers.* 
FROM watchers, chinese_users
WHERE watchers.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers(repo_id);
CREATE INDEX user_id ON chinese_watchers(user_id);

CREATE TABLE chinese_to_chinese_project_watcher_count
SELECT chinese_projects.id, COUNT(*) AS watcher_count, chinese_projects.owner_id
FROM chinese_projects, chinese_watchers
WHERE chinese_projects.id = chinese_watchers.repo_id
GROUP BY chinese_projects.id, chinese_projects.owner_id;
CREATE INDEX id ON chinese_to_chinese_project_watcher_count(id);
CREATE INDEX owner_id ON chinese_to_chinese_project_watcher_count(owner_id);

CREATE TABLE unitedstates_watchers
SELECT watchers.* 
FROM watchers, unitedstates_users
WHERE watchers.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers(repo_id);
CREATE INDEX user_id ON unitedstates_watchers(user_id);

CREATE TABLE unitedstates_to_unitedstates_project_watcher_count
SELECT unitedstates_projects.id, COUNT(*) AS watcher_count, unitedstates_projects.owner_id
FROM unitedstates_projects, unitedstates_watchers
WHERE unitedstates_projects.id = unitedstates_watchers.repo_id
GROUP BY unitedstates_projects.id, unitedstates_projects.owner_id;
CREATE INDEX id ON unitedstates_to_unitedstates_project_watcher_count(id);
CREATE INDEX owner_id ON unitedstates_to_unitedstates_project_watcher_count(owner_id);

CREATE TABLE indian_watchers
SELECT watchers.* 
FROM watchers, indian_users
WHERE watchers.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers(repo_id);
CREATE INDEX user_id ON indian_watchers(user_id);

CREATE TABLE indian_to_indian_project_watcher_count
SELECT indian_projects.id, COUNT(*) AS watcher_count, indian_projects.owner_id
FROM indian_projects, indian_watchers
WHERE indian_projects.id = indian_watchers.repo_id
GROUP BY indian_projects.id, indian_projects.owner_id;
CREATE INDEX id ON indian_to_indian_project_watcher_count(id);
CREATE INDEX owner_id ON indian_to_indian_project_watcher_count(owner_id);
/* Create Combined User Tables for Analysis */
/* Code blocks to combine the follower, fork and, watcher count data into the user tables for later ease of analysis. Five combined tables result, one for all users on the platform and one for each selected country of study. */ 

ALTER TABLE clean_users 
ADD(follower_count bigint(21), fork_count bigint(21), watcher_count bigint(21));
UPDATE clean_users
SET clean_users.follower_count = 
	(SELECT clean_users_followers_count.follower_count 
    FROM clean_users_followers_count 
    WHERE clean_users.id = clean_users_followers_count.user_id);
UPDATE clean_users
SET clean_users.fork_count = 
	(SELECT SUM(project_fork_count.fork_count) 
    FROM project_fork_count 
    WHERE clean_users.id = project_fork_count.owner_id);
UPDATE clean_users
SET clean_users.watcher_count = 
	(SELECT SUM(project_watcher_count.watcher_count) 
    FROM project_watcher_count 
    WHERE clean_users.id = project_watcher_count.owner_id);

ALTER TABLE russian_users 
ADD(follower_count bigint(21), russian_follower_count bigint(21), 
fork_count bigint(21), russian_fork_count bigint(21), 
watcher_count bigint(21), russian_watcher_count bigint(21));
UPDATE russian_users
SET russian_users.follower_count = 
	(SELECT russian_followers_count.follower_count 
    FROM russian_followers_count 
    WHERE russian_users.id = russian_followers_count.user_id);
UPDATE russian_users 
SET russian_users.russian_follower_count = 
	(SELECT russian_to_russian_follower_count.follower_count 
    FROM russian_to_russian_follower_count 
    WHERE russian_users.id = russian_to_russian_follower_count.user_id);
UPDATE russian_users
SET russian_users.fork_count = 
	(SELECT SUM(russian_project_fork_count.fork_count) 
    FROM russian_project_fork_count 
    WHERE russian_users.id = russian_project_fork_count.owner_id);
UPDATE russian_users
SET russian_users.russian_fork_count = 
	(SELECT SUM(russian_to_russian_project_fork_count.fork_count) 
    FROM russian_to_russian_project_fork_count 
    WHERE russian_users.id = russian_to_russian_project_fork_count.owner_id);
UPDATE russian_users
SET russian_users.watcher_count = 
	(SELECT SUM(russian_project_watcher_count.watcher_count) 
    FROM russian_project_watcher_count 
    WHERE russian_users.id = russian_project_watcher_count.owner_id);
UPDATE russian_users
SET russian_users.russian_watcher_count = 
	(SELECT SUM(russian_to_russian_project_watcher_count.watcher_count) 
    FROM russian_to_russian_project_watcher_count 
    WHERE russian_users.id = russian_to_russian_project_watcher_count.owner_id);

ALTER TABLE chinese_users 
ADD(follower_count bigint(21), chinese_follower_count bigint(21), 
fork_count bigint(21), chinese_fork_count bigint(21), 
watcher_count bigint(21), chinese_watcher_count bigint(21));
UPDATE chinese_users
SET chinese_users.follower_count = 
	(SELECT chinese_followers_count.follower_count 
    FROM chinese_followers_count 
    WHERE chinese_users.id = chinese_followers_count.user_id);
UPDATE chinese_users 
SET chinese_users.chinese_follower_count = 
	(SELECT chinese_to_chinese_follower_count.follower_count 
    FROM chinese_to_chinese_follower_count 
    WHERE chinese_users.id = chinese_to_chinese_follower_count.user_id);
UPDATE chinese_users
SET chinese_users.fork_count = 
	(SELECT SUM(chinese_project_fork_count.fork_count) 
    FROM chinese_project_fork_count 
    WHERE chinese_users.id = chinese_project_fork_count.owner_id);
UPDATE chinese_users
SET chinese_users.chinese_fork_count = 
	(SELECT SUM(chinese_to_chinese_project_fork_count.fork_count) 
    FROM chinese_to_chinese_project_fork_count 
    WHERE chinese_users.id = chinese_to_chinese_project_fork_count.owner_id);
UPDATE chinese_users
SET chinese_users.watcher_count = 
	(SELECT SUM(chinese_project_watcher_count.watcher_count) 
    FROM chinese_project_watcher_count 
    WHERE chinese_users.id = chinese_project_watcher_count.owner_id);
UPDATE chinese_users
SET chinese_users.chinese_watcher_count = 
	(SELECT SUM(chinese_to_chinese_project_watcher_count.watcher_count) 
    FROM chinese_to_chinese_project_watcher_count 
    WHERE chinese_users.id = chinese_to_chinese_project_watcher_count.owner_id);

ALTER TABLE unitedstates_users 
ADD(follower_count bigint(21), unitedstates_follower_count bigint(21), 
fork_count bigint(21), unitedstates_fork_count bigint(21), 
watcher_count bigint(21), unitedstates_watcher_count bigint(21));
UPDATE unitedstates_users
SET unitedstates_users.follower_count = 
	(SELECT unitedstates_followers_count.follower_count 
    FROM unitedstates_followers_count 
    WHERE unitedstates_users.id = unitedstates_followers_count.user_id);
UPDATE unitedstates_users 
SET unitedstates_users.unitedstates_follower_count = 
	(SELECT unitedstates_to_unitedstates_follower_count.follower_count 
    FROM unitedstates_to_unitedstates_follower_count 
    WHERE unitedstates_users.id = unitedstates_to_unitedstates_follower_count.user_id);
UPDATE unitedstates_users
SET unitedstates_users.fork_count = 
	(SELECT SUM(unitedstates_project_fork_count.fork_count) 
    FROM unitedstates_project_fork_count 
    WHERE unitedstates_users.id = unitedstates_project_fork_count.owner_id);
UPDATE unitedstates_users
SET unitedstates_users.unitedstates_fork_count = 
	(SELECT SUM(unitedstates_to_unitedstates_project_fork_count.fork_count) 
    FROM unitedstates_to_unitedstates_project_fork_count 
    WHERE unitedstates_users.id = unitedstates_to_unitedstates_project_fork_count.owner_id);
UPDATE unitedstates_users
SET unitedstates_users.watcher_count = 
	(SELECT SUM(unitedstates_project_watcher_count.watcher_count) 
    FROM unitedstates_project_watcher_count 
    WHERE unitedstates_users.id = unitedstates_project_watcher_count.owner_id);
UPDATE unitedstates_users
SET unitedstates_users.unitedstates_watcher_count = 
	(SELECT SUM(unitedstates_to_unitedstates_project_watcher_count.watcher_count) 
    FROM unitedstates_to_unitedstates_project_watcher_count 
    WHERE unitedstates_users.id = unitedstates_to_unitedstates_project_watcher_count.owner_id);

ALTER TABLE indian_users 
ADD(follower_count bigint(21), indian_follower_count bigint(21), 
fork_count bigint(21), indian_fork_count bigint(21), 
watcher_count bigint(21), indian_watcher_count bigint(21));
UPDATE indian_users
SET indian_users.follower_count = 
	(SELECT indian_followers_count.follower_count 
    FROM indian_followers_count 
    WHERE indian_users.id = indian_followers_count.user_id);
UPDATE indian_users 
SET indian_users.indian_follower_count = 
	(SELECT indian_to_indian_follower_count.follower_count 
    FROM indian_to_indian_follower_count 
    WHERE indian_users.id = indian_to_indian_follower_count.user_id);
UPDATE indian_users
SET indian_users.fork_count = 
	(SELECT SUM(indian_project_fork_count.fork_count) 
    FROM indian_project_fork_count 
    WHERE indian_users.id = indian_project_fork_count.owner_id);
UPDATE indian_users
SET indian_users.indian_fork_count = 
	(SELECT SUM(indian_to_indian_project_fork_count.fork_count) 
    FROM indian_to_indian_project_fork_count 
    WHERE indian_users.id = indian_to_indian_project_fork_count.owner_id);
UPDATE indian_users
SET indian_users.watcher_count = 
	(SELECT SUM(indian_project_watcher_count.watcher_count) 
    FROM indian_project_watcher_count 
    WHERE indian_users.id = indian_project_watcher_count.owner_id);
UPDATE indian_users
SET indian_users.indian_watcher_count = 
	(SELECT SUM(indian_to_indian_project_watcher_count.watcher_count) 
    FROM indian_to_indian_project_watcher_count 
    WHERE indian_users.id = indian_to_indian_project_watcher_count.owner_id);

/* Code blocks to set null values to 0. These may take some time*/

UPDATE ghtorrent_restore.clean_users
SET follower_count = 0
WHERE follower_count IS NULL;
UPDATE ghtorrent_restore.clean_users
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE ghtorrent_restore.clean_users
SET watcher_count = 0
WHERE watcher_count IS NULL;

UPDATE ghtorrent_restore.russian_users
SET follower_count = 0
WHERE follower_count IS NULL;
UPDATE ghtorrent_restore.russian_users
SET russian_follower_count = 0
WHERE russian_follower_count IS NULL;
UPDATE ghtorrent_restore.russian_users
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE ghtorrent_restore.russian_users
SET russian_fork_count = 0
WHERE russian_fork_count IS NULL;
UPDATE ghtorrent_restore.russian_users
SET watcher_count = 0
WHERE watcher_count IS NULL;
UPDATE ghtorrent_restore.russian_users
SET russian_watcher_count = 0
WHERE russian_watcher_count IS NULL;

UPDATE ghtorrent_restore.chinese_users
SET follower_count = 0
WHERE follower_count IS NULL;
UPDATE ghtorrent_restore.chinese_users
SET chinese_follower_count = 0
WHERE chinese_follower_count IS NULL;
UPDATE ghtorrent_restore.chinese_users
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE ghtorrent_restore.chinese_users
SET chinese_fork_count = 0
WHERE chinese_fork_count IS NULL;
UPDATE ghtorrent_restore.chinese_users
SET watcher_count = 0
WHERE watcher_count IS NULL;
UPDATE ghtorrent_restore.chinese_users
SET chinese_watcher_count = 0
WHERE chinese_watcher_count IS NULL;

UPDATE ghtorrent_restore.unitedstates_users
SET follower_count = 0
WHERE follower_count IS NULL;
UPDATE ghtorrent_restore.unitedstates_users
SET unitedstates_follower_count = 0
WHERE unitedstates_follower_count IS NULL;
UPDATE ghtorrent_restore.unitedstates_users
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE ghtorrent_restore.unitedstates_users
SET unitedstates_fork_count = 0
WHERE unitedstates_fork_count IS NULL;
UPDATE ghtorrent_restore.unitedstates_users
SET watcher_count = 0
WHERE watcher_count IS NULL;
UPDATE ghtorrent_restore.unitedstates_users
SET unitedstates_watcher_count = 0
WHERE unitedstates_watcher_count IS NULL;

UPDATE ghtorrent_restore.chinese_users
SET follower_count = 0
WHERE follower_count IS NULL;
UPDATE ghtorrent_restore.indian_users
SET indian_follower_count = 0
WHERE indian_follower_count IS NULL;
UPDATE ghtorrent_restore.indian_users
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE ghtorrent_restore.indian_users
SET indian_fork_count = 0
WHERE indian_fork_count IS NULL;
UPDATE ghtorrent_restore.indian_users
SET watcher_count = 0
WHERE watcher_count IS NULL;
UPDATE ghtorrent_restore.indian_users
SET indian_watcher_count = 0
WHERE indian_watcher_count IS NULL;
/* Date Limited Repository Star (Watcher) Table Creation */
/* Code blocks to create monthly star tables. Creates six tables in one-month intervals from December 2, 2018 through the database end date, June 1, 2019. These tables are used to form the star tables that are used to create the star counts in the next step. The first six code blocks create date limited star tables for stars from all sources */

CREATE TABLE watchers_june2019
SELECT watchers.*
FROM watchers
WHERE created_at BETWEEN CAST('2019-05-02' AS DATE) AND CAST('2019-06-01' AS DATE);
CREATE INDEX repo_id ON watchers_june2019 (repo_id);
CREATE INDEX user_id ON watchers_june2019 (user_id);

CREATE TABLE watchers_may2019
SELECT watchers.*
FROM watchers
WHERE created_at BETWEEN CAST('2019-04-02' AS DATE) AND CAST('2019-05-01' AS DATE);
CREATE INDEX repo_id ON watchers_may2019 (repo_id);
CREATE INDEX user_id ON watchers_may2019 (user_id);

CREATE TABLE watchers_april2019
SELECT watchers.*
FROM watchers
WHERE created_at BETWEEN CAST('2019-03-02' AS DATE) AND CAST('2019-04-01' AS DATE);
CREATE INDEX repo_id ON watchers_april2019 (repo_id);
CREATE INDEX user_id ON watchers_april2019 (user_id);

CREATE TABLE watchers_march2019
SELECT watchers.*
FROM watchers
WHERE created_at BETWEEN CAST('2019-02-02' AS DATE) AND CAST('2019-03-01' AS DATE);
CREATE INDEX repo_id ON watchers_march2019 (repo_id);
CREATE INDEX user_id ON watchers_march2019 (user_id);

CREATE TABLE watchers_february2019
SELECT watchers.*
FROM watchers
WHERE created_at BETWEEN CAST('2019-01-02' AS DATE) AND CAST('2019-02-01' AS DATE);
CREATE INDEX repo_id ON watchers_february2019 (repo_id);
CREATE INDEX user_id ON watchers_february2019 (user_id);

CREATE TABLE watchers_january2019
SELECT watchers.*
FROM watchers
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-01-01' AS DATE);
CREATE INDEX repo_id ON watchers_january2019 (repo_id);
CREATE INDEX user_id ON watchers_january2019 (user_id);

/* Code blocks to create date limited star tables for stars from national sources */

CREATE TABLE russian_watchers_june2019
SELECT watchers_june2019.*
FROM watchers_june2019, russian_users
WHERE watchers_june2019.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_june2019 (repo_id);
CREATE INDEX user_id ON russian_watchers_june2019 (user_id);

CREATE TABLE russian_watchers_may2019
SELECT watchers_may2019.*
FROM watchers_may2019, russian_users
WHERE watchers_may2019.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_may2019 (repo_id);
CREATE INDEX user_id ON russian_watchers_may2019 (user_id);

CREATE TABLE russian_watchers_april2019
SELECT watchers_april2019.*
FROM watchers_april2019, russian_users
WHERE watchers_april2019.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_april2019 (repo_id);
CREATE INDEX user_id ON russian_watchers_april2019 (user_id);

CREATE TABLE russian_watchers_march2019
SELECT watchers_march2019.*
FROM watchers_march2019, russian_users
WHERE watchers_march2019.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_march2019 (repo_id);
CREATE INDEX user_id ON russian_watchers_march2019 (user_id);

CREATE TABLE russian_watchers_february2019
SELECT watchers_february2019.*
FROM watchers_february2019, russian_users
WHERE watchers_february2019.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_february2019 (repo_id);
CREATE INDEX user_id ON russian_watchers_february2019 (user_id);

CREATE TABLE russian_watchers_january2019
SELECT watchers_january2019.*
FROM watchers_january2019, russian_users
WHERE watchers_january2019.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_january2019 (repo_id);
CREATE INDEX user_id ON russian_watchers_january2019 (user_id);
CREATE TABLE russian_watchers_june2019
SELECT watchers_june2019.*
FROM watchers_june2019, russian_users
WHERE watchers_june2019.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_june2019 (repo_id);
CREATE INDEX user_id ON russian_watchers_june2019 (user_id);

CREATE TABLE chinese_watchers_june2019
SELECT watchers_june2019.*
FROM watchers_june2019, chinese_users
WHERE watchers_june2019.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers_june2019 (repo_id);
CREATE INDEX user_id ON chinese_watchers_june2019 (user_id);

CREATE TABLE chinese_watchers_may2019
SELECT watchers_may2019.*
FROM watchers_may2019, chinese_users
WHERE watchers_may2019.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers_may2019 (repo_id);
CREATE INDEX user_id ON chinese_watchers_may2019 (user_id);

CREATE TABLE chinese_watchers_april2019
SELECT watchers_april2019.*
FROM watchers_april2019, chinese_users
WHERE watchers_april2019.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers_april2019 (repo_id);
CREATE INDEX user_id ON chinese_watchers_april2019 (user_id);

CREATE TABLE chinese_watchers_march2019
SELECT watchers_march2019.*
FROM watchers_march2019, chinese_users
WHERE watchers_march2019.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers_march2019 (repo_id);
CREATE INDEX user_id ON chinese_watchers_march2019 (user_id);

CREATE TABLE chinese_watchers_february2019
SELECT watchers_february2019.*
FROM watchers_february2019, chinese_users
WHERE watchers_february2019.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers_february2019 (repo_id);
CREATE INDEX user_id ON chinese_watchers_february2019 (user_id);

CREATE TABLE chinese_watchers_january2019
SELECT watchers_january2019.*
FROM watchers_january2019, chinese_users
WHERE watchers_january2019.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers_january2019 (repo_id);
CREATE INDEX user_id ON chinese_watchers_january2019 (user_id);

CREATE TABLE unitedstates_watchers_june2019
SELECT watchers_june2019.*
FROM watchers_june2019, unitedstates_users
WHERE watchers_june2019.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers_june2019 (repo_id);
CREATE INDEX user_id ON unitedstates_watchers_june2019 (user_id);

CREATE TABLE unitedstates_watchers_may2019
SELECT watchers_may2019.*
FROM watchers_may2019, unitedstates_users
WHERE watchers_may2019.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers_may2019 (repo_id);
CREATE INDEX user_id ON unitedstates_watchers_may2019 (user_id);

CREATE TABLE unitedstates_watchers_april2019
SELECT watchers_april2019.*
FROM watchers_april2019, unitedstates_users
WHERE watchers_april2019.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers_april2019 (repo_id);
CREATE INDEX user_id ON unitedstates_watchers_april2019 (user_id);

CREATE TABLE unitedstates_watchers_march2019
SELECT watchers_march2019.*
FROM watchers_march2019, unitedstates_users
WHERE watchers_march2019.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers_march2019 (repo_id);
CREATE INDEX user_id ON unitedstates_watchers_march2019 (user_id);

CREATE TABLE unitedstates_watchers_february2019
SELECT watchers_february2019.*
FROM watchers_february2019, unitedstates_users
WHERE watchers_february2019.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers_february2019 (repo_id);
CREATE INDEX user_id ON unitedstates_watchers_february2019 (user_id);

CREATE TABLE unitedstates_watchers_january2019
SELECT watchers_january2019.*
FROM watchers_january2019, unitedstates_users
WHERE watchers_january2019.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers_january2019 (repo_id);
CREATE INDEX user_id ON unitedstates_watchers_january2019 (user_id);

CREATE TABLE indian_watchers_june2019
SELECT watchers_june2019.*
FROM watchers_june2019, indian_users
WHERE watchers_june2019.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers_june2019 (repo_id);
CREATE INDEX user_id ON indian_watchers_june2019 (user_id);

CREATE TABLE indian_watchers_may2019
SELECT watchers_may2019.*
FROM watchers_may2019, indian_users
WHERE watchers_may2019.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers_may2019 (repo_id);
CREATE INDEX user_id ON indian_watchers_may2019 (user_id);

CREATE TABLE indian_watchers_april2019
SELECT watchers_april2019.*
FROM watchers_april2019, indian_users
WHERE watchers_april2019.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers_april2019 (repo_id);
CREATE INDEX user_id ON indian_watchers_april2019 (user_id);

CREATE TABLE indian_watchers_march2019
SELECT watchers_march2019.*
FROM watchers_march2019, indian_users
WHERE watchers_march2019.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers_march2019 (repo_id);
CREATE INDEX user_id ON indian_watchers_march2019 (user_id);

CREATE TABLE indian_watchers_february2019
SELECT watchers_february2019.*
FROM watchers_february2019, indian_users
WHERE watchers_february2019.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers_february2019 (repo_id);
CREATE INDEX user_id ON indian_watchers_february2019 (user_id);

CREATE TABLE indian_watchers_january2019
SELECT watchers_january2019.*
FROM watchers_january2019, indian_users
WHERE watchers_january2019.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers_january2019 (repo_id);
CREATE INDEX user_id ON indian_watchers_january2019 (user_id);
/* Date Limited Star Count Table Creation */
/* Code blocks to create counts of the number of stars for repositories on a monthly basis. The first six code blocks create tables of forks from all user sources. */

CREATE TABLE watchers_june2019_count
SELECT watchers_june2019.repo_id, COUNT(*) AS star_count
FROM watchers_june2019
GROUP BY watchers_june2019.repo_id;
CREATE INDEX repo_id ON watchers_june2019_count(repo_id);

CREATE TABLE watchers_may2019_count
SELECT watchers_may2019.repo_id, COUNT(*) AS star_count
FROM watchers_may2019
GROUP BY watchers_may2019.repo_id;
CREATE INDEX repo_id ON watchers_may2019_count(repo_id);

CREATE TABLE watchers_april2019_count
SELECT watchers_april2019.repo_id, COUNT(*) AS star_count
FROM watchers_april2019
GROUP BY watchers_april2019.repo_id;
CREATE INDEX repo_id ON watchers_april2019_count(repo_id);

CREATE TABLE watchers_march2019_count
SELECT watchers_march2019.repo_id, COUNT(*) AS star_count
FROM watchers_march2019
GROUP BY watchers_march2019.repo_id;
CREATE INDEX repo_id ON watchers_march2019_count(repo_id);

CREATE TABLE watchers_february2019_count
SELECT watchers_february2019.repo_id, COUNT(*) AS star_count
FROM watchers_february2019
GROUP BY watchers_february2019.repo_id;
CREATE INDEX repo_id ON watchers_february2019_count(repo_id);

CREATE TABLE watchers_january2019_count
SELECT watchers_january2019.repo_id, COUNT(*) AS star_count
FROM watchers_january2019
GROUP BY watchers_january2019.repo_id;
CREATE INDEX repo_id ON watchers_january2019_count(repo_id);

/* Code blocks to create date limited star tables for stars from national sources */

CREATE TABLE russian_watchers_june2019_count
SELECT russian_watchers_june2019.repo_id, COUNT(*) AS star_count
FROM russian_watchers_june2019
GROUP BY russian_watchers_june2019.repo_id;
CREATE INDEX repo_id ON russian_watchers_june2019_count(repo_id);

CREATE TABLE russian_watchers_may2019_count
SELECT russian_watchers_may2019.repo_id, COUNT(*) AS star_count
FROM russian_watchers_may2019
GROUP BY russian_watchers_may2019.repo_id;
CREATE INDEX repo_id ON russian_watchers_may2019_count(repo_id);

CREATE TABLE russian_watchers_april2019_count
SELECT russian_watchers_april2019.repo_id, COUNT(*) AS star_count
FROM russian_watchers_april2019
GROUP BY russian_watchers_april2019.repo_id;
CREATE INDEX repo_id ON russian_watchers_april2019_count(repo_id);

CREATE TABLE russian_watchers_march2019_count
SELECT russian_watchers_march2019.repo_id, COUNT(*) AS star_count
FROM russian_watchers_march2019
GROUP BY russian_watchers_march2019.repo_id;
CREATE INDEX repo_id ON russian_watchers_march2019_count(repo_id);

CREATE TABLE russian_watchers_february2019_count
SELECT russian_watchers_february2019.repo_id, COUNT(*) AS star_count
FROM russian_watchers_february2019
GROUP BY russian_watchers_february2019.repo_id;
CREATE INDEX repo_id ON russian_watchers_february2019_count(repo_id);

CREATE TABLE russian_watchers_january2019_count
SELECT russian_watchers_january2019.repo_id, COUNT(*) AS star_count
FROM russian_watchers_january2019
GROUP BY russian_watchers_january2019.repo_id;
CREATE INDEX repo_id ON russian_watchers_january2019_count(repo_id);

CREATE TABLE chinese_watchers_june2019_count
SELECT chinese_watchers_june2019.repo_id, COUNT(*) AS star_count
FROM chinese_watchers_june2019
GROUP BY chinese_watchers_june2019.repo_id;
CREATE INDEX repo_id ON chinese_watchers_june2019_count(repo_id);

CREATE TABLE chinese_watchers_may2019_count
SELECT chinese_watchers_may2019.repo_id, COUNT(*) AS star_count
FROM chinese_watchers_may2019
GROUP BY chinese_watchers_may2019.repo_id;
CREATE INDEX repo_id ON chinese_watchers_may2019_count(repo_id);

CREATE TABLE chinese_watchers_april2019_count
SELECT chinese_watchers_april2019.repo_id, COUNT(*) AS star_count
FROM chinese_watchers_april2019
GROUP BY chinese_watchers_april2019.repo_id;
CREATE INDEX repo_id ON chinese_watchers_april2019_count(repo_id);

CREATE TABLE chinese_watchers_march2019_count
SELECT chinese_watchers_march2019.repo_id, COUNT(*) AS star_count
FROM chinese_watchers_march2019
GROUP BY chinese_watchers_march2019.repo_id;
CREATE INDEX repo_id ON chinese_watchers_march2019_count(repo_id);

CREATE TABLE chinese_watchers_february2019_count
SELECT chinese_watchers_february2019.repo_id, COUNT(*) AS star_count
FROM chinese_watchers_february2019
GROUP BY chinese_watchers_february2019.repo_id;
CREATE INDEX repo_id ON chinese_watchers_february2019_count(repo_id);

CREATE TABLE chinese_watchers_january2019_count
SELECT chinese_watchers_january2019.repo_id, COUNT(*) AS star_count
FROM chinese_watchers_january2019
GROUP BY chinese_watchers_january2019.repo_id;
CREATE INDEX repo_id ON chinese_watchers_january2019_count(repo_id);

CREATE TABLE unitedstates_watchers_june2019_count
SELECT unitedstates_watchers_june2019.repo_id, COUNT(*) AS star_count
FROM unitedstates_watchers_june2019
GROUP BY unitedstates_watchers_june2019.repo_id;
CREATE INDEX repo_id ON unitedstates_watchers_june2019_count(repo_id);

CREATE TABLE unitedstates_watchers_may2019_count
SELECT unitedstates_watchers_may2019.repo_id, COUNT(*) AS star_count
FROM unitedstates_watchers_may2019
GROUP BY unitedstates_watchers_may2019.repo_id;
CREATE INDEX repo_id ON unitedstates_watchers_may2019_count(repo_id);

CREATE TABLE unitedstates_watchers_april2019_count
SELECT unitedstates_watchers_april2019.repo_id, COUNT(*) AS star_count
FROM unitedstates_watchers_april2019
GROUP BY unitedstates_watchers_april2019.repo_id;
CREATE INDEX repo_id ON unitedstates_watchers_april2019_count(repo_id);

CREATE TABLE unitedstates_watchers_march2019_count
SELECT unitedstates_watchers_march2019.repo_id, COUNT(*) AS star_count
FROM unitedstates_watchers_march2019
GROUP BY unitedstates_watchers_march2019.repo_id;
CREATE INDEX repo_id ON unitedstates_watchers_march2019_count(repo_id);

CREATE TABLE unitedstates_watchers_february2019_count
SELECT unitedstates_watchers_february2019.repo_id, COUNT(*) AS star_count
FROM unitedstates_watchers_february2019
GROUP BY unitedstates_watchers_february2019.repo_id;
CREATE INDEX repo_id ON unitedstates_watchers_february2019_count(repo_id);

CREATE TABLE unitedstates_watchers_january2019_count
SELECT unitedstates_watchers_january2019.repo_id, COUNT(*) AS star_count
FROM unitedstates_watchers_january2019
GROUP BY unitedstates_watchers_january2019.repo_id;
CREATE INDEX repo_id ON unitedstates_watchers_january2019_count(repo_id);

CREATE TABLE indian_watchers_june2019_count
SELECT indian_watchers_june2019.repo_id, COUNT(*) AS star_count
FROM indian_watchers_june2019
GROUP BY indian_watchers_june2019.repo_id;
CREATE INDEX repo_id ON indian_watchers_june2019_count(repo_id);

CREATE TABLE indian_watchers_may2019_count
SELECT indian_watchers_may2019.repo_id, COUNT(*) AS star_count
FROM indian_watchers_may2019
GROUP BY indian_watchers_may2019.repo_id;
CREATE INDEX repo_id ON indian_watchers_may2019_count(repo_id);

CREATE TABLE indian_watchers_april2019_count
SELECT indian_watchers_april2019.repo_id, COUNT(*) AS star_count
FROM indian_watchers_april2019
GROUP BY indian_watchers_april2019.repo_id;
CREATE INDEX repo_id ON indian_watchers_april2019_count(repo_id);

CREATE TABLE indian_watchers_march2019_count
SELECT indian_watchers_march2019.repo_id, COUNT(*) AS star_count
FROM indian_watchers_march2019
GROUP BY indian_watchers_march2019.repo_id;
CREATE INDEX repo_id ON indian_watchers_march2019_count(repo_id);

CREATE TABLE indian_watchers_february2019_count
SELECT indian_watchers_february2019.repo_id, COUNT(*) AS star_count
FROM indian_watchers_february2019
GROUP BY indian_watchers_february2019.repo_id;
CREATE INDEX repo_id ON indian_watchers_february2019_count(repo_id);

CREATE TABLE indian_watchers_january2019_count
SELECT indian_watchers_january2019.repo_id, COUNT(*) AS star_count
FROM indian_watchers_january2019
GROUP BY indian_watchers_january2019.repo_id;
CREATE INDEX repo_id ON indian_watchers_january2019_count(repo_id);
/* Date Limited Repository Fork Table Creation */
/* Code blocks to create monthly fork tables. Creates six tables in one-month intervals from December 2, 2018 through the database end date, June 1, 2019. These tables are used to form the fork tables are used to create the fork counts in the next step. The first six code blocks create date limited fork tables for forks from all sources */

CREATE TABLE forks_june2019
SELECT projects.*
FROM projects
WHERE created_at BETWEEN CAST('2019-05-02' AS DATE) AND CAST('2019-06-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON forks_june2019(id);
CREATE INDEX owner_id ON forks_june2019(owner_id);
CREATE INDEX forked_from ON forks_june2019(forked_from);

CREATE TABLE forks_may2019
SELECT projects.*
FROM projects
WHERE created_at BETWEEN CAST('2019-04-02' AS DATE) AND CAST('2019-05-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON forks_may2019(id);
CREATE INDEX owner_id ON forks_may2019(owner_id);
CREATE INDEX forked_from ON forks_may2019(forked_from);

CREATE TABLE forks_april2019
SELECT projects.*
FROM projects
WHERE created_at BETWEEN CAST('2019-03-02' AS DATE) AND CAST('2019-04-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON forks_april2019(id);
CREATE INDEX owner_id ON forks_april2019(owner_id);
CREATE INDEX forked_from ON forks_april2019(forked_from);

CREATE TABLE forks_march2019
SELECT projects.*
FROM projects
WHERE created_at BETWEEN CAST('2019-02-02' AS DATE) AND CAST('2019-03-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON forks_march2019(id);
CREATE INDEX owner_id ON forks_march2019(owner_id);
CREATE INDEX forked_from ON forks_march2019(forked_from);

CREATE TABLE forks_february2019
SELECT projects.*
FROM projects
WHERE created_at BETWEEN CAST('2019-01-02' AS DATE) AND CAST('2019-02-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON forks_february2019(id);
CREATE INDEX owner_id ON forks_february2019(owner_id);
CREATE INDEX forked_from ON forks_february2019(forked_from);

CREATE TABLE forks_january2019
SELECT projects.*
FROM projects
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-01-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON forks_january2019(id);
CREATE INDEX owner_id ON forks_january2019(owner_id);
CREATE INDEX forked_from ON forks_january2019(forked_from);

/* Code blocks to create date limited fork tables for forks from national sources */

CREATE TABLE russian_forks_june2019
SELECT russian_projects.*
FROM russian_projects
WHERE created_at BETWEEN CAST('2019-05-02' AS DATE) AND CAST('2019-06-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON russian_forks_june2019(id);
CREATE INDEX owner_id ON russian_forks_june2019(owner_id);
CREATE INDEX forked_from ON russian_forks_june2019(forked_from);

CREATE TABLE russian_forks_may2019
SELECT russian_projects.*
FROM russian_projects
WHERE created_at BETWEEN CAST('2019-04-02' AS DATE) AND CAST('2019-05-01' AS DATE) 
AND forked_from IS NOT NULL;
CREATE INDEX id ON russian_forks_may2019(id);
CREATE INDEX owner_id ON russian_forks_may2019(owner_id);
CREATE INDEX forked_from ON russian_forks_may2019(forked_from);

CREATE TABLE russian_forks_april2019
SELECT russian_projects.*
FROM russian_projects
WHERE created_at BETWEEN CAST('2019-03-02' AS DATE) AND CAST('2019-04-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON russian_forks_april2019(id);
CREATE INDEX owner_id ON russian_forks_april2019(owner_id);
CREATE INDEX forked_from ON russian_forks_april2019(forked_from);

CREATE TABLE russian_forks_march2019
SELECT russian_projects.*
FROM russian_projects
WHERE created_at BETWEEN CAST('2019-02-02' AS DATE) AND CAST('2019-03-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON russian_forks_march2019(id);
CREATE INDEX owner_id ON russian_forks_march2019(owner_id);
CREATE INDEX forked_from ON russian_forks_march2019(forked_from);

CREATE TABLE russian_forks_february2019
SELECT russian_projects.*
FROM russian_projects
WHERE created_at BETWEEN CAST('2019-01-02' AS DATE) AND CAST('2019-02-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON russian_forks_february2019(id);
CREATE INDEX owner_id ON russian_forks_february2019(owner_id);
CREATE INDEX forked_from ON russian_forks_february2019(forked_from);

CREATE TABLE russian_forks_january2019
SELECT russian_projects.*
FROM russian_projects
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-01-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON russian_forks_january2019(id);
CREATE INDEX owner_id ON russian_forks_january2019(owner_id);
CREATE INDEX forked_from ON russian_forks_january2019(forked_from);

CREATE TABLE chinese_forks_june2019
SELECT chinese_projects.*
FROM chinese_projects
WHERE created_at BETWEEN CAST('2019-05-02' AS DATE) AND CAST('2019-06-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON chinese_forks_june2019(id);
CREATE INDEX owner_id ON chinese_forks_june2019(owner_id);
CREATE INDEX forked_from ON chinese_forks_june2019(forked_from);

CREATE TABLE chinese_forks_may2019
SELECT chinese_projects.*
FROM chinese_projects
WHERE created_at BETWEEN CAST('2019-04-02' AS DATE) AND CAST('2019-05-01' AS DATE) 
AND forked_from IS NOT NULL;
CREATE INDEX id ON chinese_forks_may2019(id);
CREATE INDEX owner_id ON chinese_forks_may2019(owner_id);
CREATE INDEX forked_from ON chinese_forks_may2019(forked_from);

CREATE TABLE chinese_forks_april2019
SELECT chinese_projects.*
FROM chinese_projects
WHERE created_at BETWEEN CAST('2019-03-02' AS DATE) AND CAST('2019-04-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON chinese_forks_april2019(id);
CREATE INDEX owner_id ON chinese_forks_april2019(owner_id);
CREATE INDEX forked_from ON chinese_forks_april2019(forked_from);

CREATE TABLE chinese_forks_march2019
SELECT chinese_projects.*
FROM chinese_projects
WHERE created_at BETWEEN CAST('2019-02-02' AS DATE) AND CAST('2019-03-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON chinese_forks_march2019(id);
CREATE INDEX owner_id ON chinese_forks_march2019(owner_id);
CREATE INDEX forked_from ON chinese_forks_march2019(forked_from);

CREATE TABLE chinese_forks_february2019
SELECT chinese_projects.*
FROM chinese_projects
WHERE created_at BETWEEN CAST('2019-01-02' AS DATE) AND CAST('2019-02-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON chinese_forks_february2019(id);
CREATE INDEX owner_id ON chinese_forks_february2019(owner_id);
CREATE INDEX forked_from ON chinese_forks_february2019(forked_from);

CREATE TABLE chinese_forks_january2019
SELECT chinese_projects.*
FROM chinese_projects
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-01-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON chinese_forks_january2019(id);
CREATE INDEX owner_id ON chinese_forks_january2019(owner_id);
CREATE INDEX forked_from ON chinese_forks_january2019(forked_from);

CREATE TABLE unitedstates_forks_june2019
SELECT unitedstates_projects.*
FROM unitedstates_projects
WHERE created_at BETWEEN CAST('2019-05-02' AS DATE) AND CAST('2019-06-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON unitedstates_forks_june2019(id);
CREATE INDEX owner_id ON unitedstates_forks_june2019(owner_id);
CREATE INDEX forked_from ON unitedstates_forks_june2019(forked_from);

CREATE TABLE unitedstates_forks_may2019
SELECT unitedstates_projects.*
FROM unitedstates_projects
WHERE created_at BETWEEN CAST('2019-04-02' AS DATE) AND CAST('2019-05-01' AS DATE) 
AND forked_from IS NOT NULL;
CREATE INDEX id ON unitedstates_forks_may2019(id);
CREATE INDEX owner_id ON unitedstates_forks_may2019(owner_id);
CREATE INDEX forked_from ON unitedstates_forks_may2019(forked_from);

CREATE TABLE unitedstates_forks_april2019
SELECT unitedstates_projects.*
FROM unitedstates_projects
WHERE created_at BETWEEN CAST('2019-03-02' AS DATE) AND CAST('2019-04-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON unitedstates_forks_april2019(id);
CREATE INDEX owner_id ON unitedstates_forks_april2019(owner_id);
CREATE INDEX forked_from ON unitedstates_forks_april2019(forked_from);

CREATE TABLE unitedstates_forks_march2019
SELECT unitedstates_projects.*
FROM unitedstates_projects
WHERE created_at BETWEEN CAST('2019-02-02' AS DATE) AND CAST('2019-03-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON unitedstates_forks_march2019(id);
CREATE INDEX owner_id ON unitedstates_forks_march2019(owner_id);
CREATE INDEX forked_from ON unitedstates_forks_march2019(forked_from);

CREATE TABLE unitedstates_forks_february2019
SELECT unitedstates_projects.*
FROM unitedstates_projects
WHERE created_at BETWEEN CAST('2019-01-02' AS DATE) AND CAST('2019-02-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON unitedstates_forks_february2019(id);
CREATE INDEX owner_id ON unitedstates_forks_february2019(owner_id);
CREATE INDEX forked_from ON unitedstates_forks_february2019(forked_from);

CREATE TABLE unitedstates_forks_january2019
SELECT unitedstates_projects.*
FROM unitedstates_projects
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-01-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON unitedstates_forks_january2019(id);
CREATE INDEX owner_id ON unitedstates_forks_january2019(owner_id);
CREATE INDEX forked_from ON unitedstates_forks_january2019(forked_from);

CREATE TABLE indian_forks_june2019
SELECT indian_projects.*
FROM indian_projects
WHERE created_at BETWEEN CAST('2019-05-02' AS DATE) AND CAST('2019-06-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON indian_forks_june2019(id);
CREATE INDEX owner_id ON indian_forks_june2019(owner_id);
CREATE INDEX forked_from ON indian_forks_june2019(forked_from);

CREATE TABLE indian_forks_may2019
SELECT indian_projects.*
FROM indian_projects
WHERE created_at BETWEEN CAST('2019-04-02' AS DATE) AND CAST('2019-05-01' AS DATE) 
AND forked_from IS NOT NULL;
CREATE INDEX id ON indian_forks_may2019(id);
CREATE INDEX owner_id ON indian_forks_may2019(owner_id);
CREATE INDEX forked_from ON indian_forks_may2019(forked_from);

CREATE TABLE indian_forks_april2019
SELECT indian_projects.*
FROM indian_projects
WHERE created_at BETWEEN CAST('2019-03-02' AS DATE) AND CAST('2019-04-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON indian_forks_april2019(id);
CREATE INDEX owner_id ON indian_forks_april2019(owner_id);
CREATE INDEX forked_from ON indian_forks_april2019(forked_from);

CREATE TABLE indian_forks_march2019
SELECT indian_projects.*
FROM indian_projects
WHERE created_at BETWEEN CAST('2019-02-02' AS DATE) AND CAST('2019-03-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON indian_forks_march2019(id);
CREATE INDEX owner_id ON indian_forks_march2019(owner_id);
CREATE INDEX forked_from ON indian_forks_march2019(forked_from);

CREATE TABLE indian_forks_february2019
SELECT indian_projects.*
FROM indian_projects
WHERE created_at BETWEEN CAST('2019-01-02' AS DATE) AND CAST('2019-02-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON indian_forks_february2019(id);
CREATE INDEX owner_id ON indian_forks_february2019(owner_id);
CREATE INDEX forked_from ON indian_forks_february2019(forked_from);

CREATE TABLE indian_forks_january2019
SELECT indian_projects.*
FROM indian_projects
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-01-01' AS DATE)
AND forked_from IS NOT NULL;
CREATE INDEX id ON indian_forks_january2019(id);
CREATE INDEX owner_id ON indian_forks_january2019(owner_id);
CREATE INDEX forked_from ON indian_forks_january2019(forked_from);
/* Date Limited Fork Count Table Creation */
/* Code blocks to create counts of the number of forks created on a monthly basis. A weighted score is also calculated and applied to each row as weighted_fork_count. The first six code blocks create tables of forks from all user sources. */

CREATE TABLE forks_june2019_count
SELECT projects.id, count(*) AS fork_count
FROM forks_june2019, projects
WHERE forks_june2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON forks_june2019_count(id);
ALTER TABLE forks_june2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE forks_june2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE forks_may2019_count
SELECT projects.id, count(*) AS fork_count
FROM forks_may2019, projects
WHERE forks_may2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON forks_may2019_count(id);
ALTER TABLE forks_may2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE forks_may2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE forks_april2019_count
SELECT projects.id, count(*) AS fork_count
FROM forks_april2019, projects
WHERE forks_april2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON forks_april2019_count(id);
ALTER TABLE forks_april2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE forks_april2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE forks_march2019_count
SELECT projects.id, count(*) AS fork_count
FROM forks_march2019, projects
WHERE forks_march2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON forks_march2019_count(id);
ALTER TABLE forks_march2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE forks_march2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE forks_february2019_count
SELECT projects.id, count(*) AS fork_count
FROM forks_february2019, projects
WHERE forks_february2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON forks_february2019_count(id);
ALTER TABLE forks_february2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE forks_february2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE forks_january2019_count
SELECT projects.id, count(*) AS fork_count
FROM forks_january2019, projects
WHERE forks_january2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON forks_january2019_count(id);
ALTER TABLE forks_january2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE forks_january2019_count
SET weighted_fork_count = (fork_count * 0.75);

/* Code blocks to created date limited fork counts from country specific user sources. */

CREATE TABLE russian_forks_june2019_count
SELECT projects.id, count(*) AS fork_count
FROM russian_forks_june2019, projects
WHERE russian_forks_june2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON russian_forks_june2019_count(id);
ALTER TABLE russian_forks_june2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE russian_forks_june2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE russian_forks_may2019_count
SELECT projects.id, count(*) AS fork_count
FROM russian_forks_may2019, projects
WHERE russian_forks_may2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON russian_forks_may2019_count(id);
ALTER TABLE russian_forks_may2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE russian_forks_may2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE russian_forks_april2019_count
SELECT projects.id, count(*) AS fork_count
FROM russian_forks_april2019, projects
WHERE russian_forks_april2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON russian_forks_april2019_count(id);
ALTER TABLE russian_forks_april2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE russian_forks_april2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE russian_forks_march2019_count
SELECT projects.id, count(*) AS fork_count
FROM russian_forks_march2019, projects
WHERE russian_forks_march2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON russian_forks_march2019_count(id);
ALTER TABLE russian_forks_march2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE russian_forks_march2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE russian_forks_february2019_count
SELECT projects.id, count(*) AS fork_count
FROM russian_forks_february2019, projects
WHERE russian_forks_february2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON russian_forks_february2019_count(id);
ALTER TABLE russian_forks_february2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE russian_forks_february2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE russian_forks_january2019_count
SELECT projects.id, count(*) AS fork_count
FROM russian_forks_january2019, projects
WHERE russian_forks_january2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON russian_forks_january2019_count(id);
ALTER TABLE russian_forks_january2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE russian_forks_january2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE chinese_forks_june2019_count
SELECT projects.id, count(*) AS fork_count
FROM chinese_forks_june2019, projects
WHERE chinese_forks_june2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON chinese_forks_june2019_count(id);
ALTER TABLE chinese_forks_june2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE chinese_forks_june2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE chinese_forks_may2019_count
SELECT projects.id, count(*) AS fork_count
FROM chinese_forks_may2019, projects
WHERE chinese_forks_may2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON chinese_forks_may2019_count(id);
ALTER TABLE chinese_forks_may2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE chinese_forks_may2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE chinese_forks_april2019_count
SELECT projects.id, count(*) AS fork_count
FROM chinese_forks_april2019, projects
WHERE chinese_forks_april2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON chinese_forks_april2019_count(id);
ALTER TABLE chinese_forks_april2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE chinese_forks_april2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE chinese_forks_march2019_count
SELECT projects.id, count(*) AS fork_count
FROM chinese_forks_march2019, projects
WHERE chinese_forks_march2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON chinese_forks_march2019_count(id);
ALTER TABLE chinese_forks_march2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE chinese_forks_march2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE chinese_forks_february2019_count
SELECT projects.id, count(*) AS fork_count
FROM chinese_forks_february2019, projects
WHERE chinese_forks_february2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON chinese_forks_february2019_count(id);
ALTER TABLE chinese_forks_february2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE chinese_forks_february2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE chinese_forks_january2019_count
SELECT projects.id, count(*) AS fork_count
FROM chinese_forks_january2019, projects
WHERE chinese_forks_january2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON chinese_forks_january2019_count(id);
ALTER TABLE chinese_forks_january2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE chinese_forks_january2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE unitedstates_forks_june2019_count
SELECT projects.id, count(*) AS fork_count
FROM unitedstates_forks_june2019, projects
WHERE unitedstates_forks_june2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON unitedstates_forks_june2019_count(id);
ALTER TABLE unitedstates_forks_june2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE unitedstates_forks_june2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE unitedstates_forks_may2019_count
SELECT projects.id, count(*) AS fork_count
FROM unitedstates_forks_may2019, projects
WHERE unitedstates_forks_may2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON unitedstates_forks_may2019_count(id);
ALTER TABLE unitedstates_forks_may2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE unitedstates_forks_may2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE unitedstates_forks_april2019_count
SELECT projects.id, count(*) AS fork_count
FROM unitedstates_forks_april2019, projects
WHERE unitedstates_forks_april2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON unitedstates_forks_april2019_count(id);
ALTER TABLE unitedstates_forks_april2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE unitedstates_forks_april2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE unitedstates_forks_march2019_count
SELECT projects.id, count(*) AS fork_count
FROM unitedstates_forks_march2019, projects
WHERE unitedstates_forks_march2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON unitedstates_forks_march2019_count(id);
ALTER TABLE unitedstates_forks_march2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE unitedstates_forks_march2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE unitedstates_forks_february2019_count
SELECT projects.id, count(*) AS fork_count
FROM unitedstates_forks_february2019, projects
WHERE unitedstates_forks_february2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON unitedstates_forks_february2019_count(id);
ALTER TABLE unitedstates_forks_february2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE unitedstates_forks_february2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE unitedstates_forks_january2019_count
SELECT projects.id, count(*) AS fork_count
FROM unitedstates_forks_january2019, projects
WHERE unitedstates_forks_january2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON unitedstates_forks_january2019_count(id);
ALTER TABLE unitedstates_forks_january2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE unitedstates_forks_january2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE indian_forks_june2019_count
SELECT projects.id, count(*) AS fork_count
FROM indian_forks_june2019, projects
WHERE indian_forks_june2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON indian_forks_june2019_count(id);
ALTER TABLE indian_forks_june2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE indian_forks_june2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE indian_forks_may2019_count
SELECT projects.id, count(*) AS fork_count
FROM indian_forks_may2019, projects
WHERE indian_forks_may2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON indian_forks_may2019_count(id);
ALTER TABLE indian_forks_may2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE indian_forks_may2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE indian_forks_april2019_count
SELECT projects.id, count(*) AS fork_count
FROM indian_forks_april2019, projects
WHERE indian_forks_april2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON indian_forks_april2019_count(id);
ALTER TABLE indian_forks_april2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE indian_forks_april2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE indian_forks_march2019_count
SELECT projects.id, count(*) AS fork_count
FROM indian_forks_march2019, projects
WHERE indian_forks_march2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON indian_forks_march2019_count(id);
ALTER TABLE indian_forks_march2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE indian_forks_march2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE indian_forks_february2019_count
SELECT projects.id, count(*) AS fork_count
FROM indian_forks_february2019, projects
WHERE indian_forks_february2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON indian_forks_february2019_count(id);
ALTER TABLE indian_forks_february2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE indian_forks_february2019_count
SET weighted_fork_count = (fork_count * 0.75);

CREATE TABLE indian_forks_january2019_count
SELECT projects.id, count(*) AS fork_count
FROM indian_forks_january2019, projects
WHERE indian_forks_january2019.forked_from = projects.id
GROUP BY projects.id;
CREATE INDEX id ON indian_forks_january2019_count(id);
ALTER TABLE indian_forks_january2019_count
ADD(weighted_fork_count FLOAT(21));
UPDATE indian_forks_january2019_count
SET weighted_fork_count = (fork_count * 0.75);
/* Create Combined Repository Star/Fork (Influence) Tables and Influence Scores for Analyis */
/* Code blocks to create date limited star/fork tables and perform calculations to develop influence scores for each starred/forked repository during the time period. The first six code blocks perform this function for repositories that received star/forks from all sources. */

CREATE TABLE projects_influence_june2019
SELECT * FROM watchers_june2019_count
LEFT JOIN forks_june2019_count ON watchers_june2019_count.repo_id = forks_june2019_count.id
UNION ALL
SELECT * FROM watchers_june2019_count
RIGHT JOIN forks_june2019_count ON watchers_june2019_count.repo_id = forks_june2019_count.id
WHERE watchers_june2019_count.repo_id IS NULL;
UPDATE projects_influence_june2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE projects_influence_june2019
DROP COLUMN id;
ALTER TABLE projects_influence_june2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), 
code_language VARCHAR(255), forked_from INT(11));
UPDATE projects_influence_june2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE projects_influence_june2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE projects_influence_june2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE projects_influence_june2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM watchers_june2019_count), fork_total = (SELECT SUM(fork_count) FROM forks_june2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM forks_june2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE projects_influence_june2019
SET repo_name = (SELECT projects.name FROM projects WHERE projects_influence_june2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE projects_influence_june2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE projects_influence_june2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE projects_influence_june2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE
projects_influence_june2019.owner_id = users.id)
code_language = (SELECT projects.language FROM projects WHERE projects_influence_june2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE projects_influence_june2019.repo_id = projects.id);

CREATE TABLE projects_influence_may2019
SELECT * FROM watchers_may2019_count
LEFT JOIN forks_may2019_count ON watchers_may2019_count.repo_id = forks_may2019_count.id
UNION ALL
SELECT * FROM watchers_may2019_count
RIGHT JOIN forks_may2019_count ON watchers_may2019_count.repo_id = forks_may2019_count.id
WHERE watchers_may2019_count.repo_id IS NULL;
UPDATE projects_influence_may2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE projects_influence_may2019
DROP COLUMN id;
ALTER TABLE projects_influence_may2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE projects_influence_may2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE projects_influence_may2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE projects_influence_may2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE projects_influence_may2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM watchers_may2019_count), fork_total = (SELECT SUM(fork_count) FROM forks_may2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM forks_may2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE projects_influence_may2019
SET repo_name = (SELECT projects.name FROM projects WHERE projects_influence_may2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE projects_influence_may2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE projects_influence_may2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE projects_influence_may2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE projects_influence_may2019.owner_id = users.id),
code_language = (SELECT projects.language FROM projects WHERE projects_influence_may2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE projects_influence_may2019.repo_id = projects.id);

CREATE TABLE projects_influence_april2019
SELECT * FROM watchers_april2019_count
LEFT JOIN forks_april2019_count ON watchers_april2019_count.repo_id = forks_april2019_count.id
UNION ALL
SELECT * FROM watchers_april2019_count
RIGHT JOIN forks_april2019_count ON watchers_april2019_count.repo_id = forks_april2019_count.id
WHERE watchers_april2019_count.repo_id IS NULL;
UPDATE projects_influence_april2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE projects_influence_april2019
DROP COLUMN id;
ALTER TABLE projects_influence_april2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));UPDATE projects_influence_april2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE projects_influence_april2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE projects_influence_april2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE projects_influence_april2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM watchers_april2019_count), fork_total = (SELECT SUM(fork_count) FROM forks_april2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM forks_april2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE projects_influence_april2019
SET repo_name = (SELECT projects.name FROM projects WHERE projects_influence_april2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE projects_influence_april2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE projects_influence_april2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE projects_influence_april2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE projects_influence_april2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE projects_influence_april2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE projects_influence_april2019.repo_id = projects.id);

CREATE TABLE projects_influence_march2019
SELECT * FROM watchers_march2019_count
LEFT JOIN forks_march2019_count ON watchers_march2019_count.repo_id = forks_march2019_count.id
UNION ALL
SELECT * FROM watchers_march2019_count
RIGHT JOIN forks_march2019_count ON watchers_march2019_count.repo_id = forks_march2019_count.id
WHERE watchers_march2019_count.repo_id IS NULL;
UPDATE projects_influence_march2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE projects_influence_march2019
DROP COLUMN id;
ALTER TABLE projects_influence_march2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE projects_influence_march2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE projects_influence_march2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE projects_influence_march2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE projects_influence_march2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM watchers_march2019_count), fork_total = (SELECT SUM(fork_count) FROM forks_march2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM forks_march2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE projects_influence_march2019
SET repo_name = (SELECT projects.name FROM projects WHERE projects_influence_march2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE projects_influence_march2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE projects_influence_march2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE projects_influence_march2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE projects_influence_march2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE projects_influence_march2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE projects_influence_march2019.repo_id = projects.id);

CREATE TABLE projects_influence_february2019
SELECT * FROM watchers_february2019_count
LEFT JOIN forks_february2019_count ON watchers_february2019_count.repo_id = forks_february2019_count.id
UNION ALL
SELECT * FROM watchers_february2019_count
RIGHT JOIN forks_february2019_count ON watchers_february2019_count.repo_id = forks_february2019_count.id
WHERE watchers_february2019_count.repo_id IS NULL;
UPDATE projects_influence_february2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE projects_influence_february2019
DROP COLUMN id;
ALTER TABLE projects_influence_february2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE projects_influence_february2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE projects_influence_february2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE projects_influence_february2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE projects_influence_february2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM watchers_february2019_count), fork_total = (SELECT SUM(fork_count) FROM forks_february2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM forks_february2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE projects_influence_february2019
SET repo_name = (SELECT projects.name FROM projects WHERE projects_influence_february2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE projects_influence_february2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE projects_influence_february2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE projects_influence_february2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE projects_influence_february2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE projects_influence_february2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE projects_influence_february2019.repo_id = projects.id);

CREATE TABLE projects_influence_january2019
SELECT * FROM watchers_january2019_count
LEFT JOIN forks_january2019_count ON watchers_january2019_count.repo_id = forks_january2019_count.id
UNION ALL
SELECT * FROM watchers_january2019_count
RIGHT JOIN forks_january2019_count ON watchers_january2019_count.repo_id = forks_january2019_count.id
WHERE watchers_january2019_count.repo_id IS NULL;
UPDATE projects_influence_january2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE projects_influence_january2019
DROP COLUMN id;
ALTER TABLE projects_influence_january2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE projects_influence_january2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE projects_influence_january2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE projects_influence_january2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE projects_influence_january2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM watchers_january2019_count), fork_total = (SELECT SUM(fork_count) FROM forks_january2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM forks_january2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE projects_influence_january2019
SET repo_name = (SELECT projects.name FROM projects WHERE projects_influence_january2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE projects_influence_january2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE projects_influence_january2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE projects_influence_january2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE projects_influence_january2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE projects_influence_january2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE projects_influence_january2019.repo_id = projects.id);

 /* Code blocks to create time date limited influence tables for repositories receiving stars/forks from national sources. */

CREATE TABLE russian_projects_influence_june2019
SELECT * FROM russian_watchers_june2019_count
LEFT JOIN russian_forks_june2019_count ON russian_watchers_june2019_count.repo_id = russian_forks_june2019_count.id
UNION ALL
SELECT * FROM russian_watchers_june2019_count
RIGHT JOIN russian_forks_june2019_count ON russian_watchers_june2019_count.repo_id = russian_forks_june2019_count.id
WHERE russian_watchers_june2019_count.repo_id IS NULL;
UPDATE russian_projects_influence_june2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE russian_projects_influence_june2019
DROP COLUMN id;
ALTER TABLE russian_projects_influence_june2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE russian_projects_influence_june2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE russian_projects_influence_june2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE russian_projects_influence_june2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE russian_projects_influence_june2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM russian_watchers_june2019_count), fork_total = (SELECT SUM(fork_count) FROM russian_forks_june2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM russian_forks_june2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE russian_projects_influence_june2019
SET repo_name = (SELECT projects.name FROM projects WHERE russian_projects_influence_june2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE russian_projects_influence_june2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE russian_projects_influence_june2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE russian_projects_influence_june2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE russian_projects_influence_june2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE russian_projects_influence_june2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE russian_projects_influence_june2019.repo_id = projects.id);

CREATE TABLE russian_projects_influence_may2019
SELECT * FROM russian_watchers_may2019_count
LEFT JOIN russian_forks_may2019_count ON russian_watchers_may2019_count.repo_id = russian_forks_may2019_count.id
UNION ALL
SELECT * FROM russian_watchers_may2019_count
RIGHT JOIN russian_forks_may2019_count ON russian_watchers_may2019_count.repo_id = russian_forks_may2019_count.id
WHERE russian_watchers_may2019_count.repo_id IS NULL;
UPDATE russian_projects_influence_may2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE russian_projects_influence_may2019
DROP COLUMN id;
ALTER TABLE russian_projects_influence_may2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE russian_projects_influence_may2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE russian_projects_influence_may2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE russian_projects_influence_may2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE russian_projects_influence_may2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM russian_watchers_may2019_count), fork_total = (SELECT SUM(fork_count) FROM russian_forks_may2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM russian_forks_may2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE russian_projects_influence_may2019
SET repo_name = (SELECT projects.name FROM projects WHERE russian_projects_influence_may2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE russian_projects_influence_may2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE russian_projects_influence_may2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE russian_projects_influence_may2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE russian_projects_influence_may2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE russian_projects_influence_may2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE russian_projects_influence_may2019.repo_id = projects.id);

CREATE TABLE russian_projects_influence_april2019
SELECT * FROM russian_watchers_april2019_count
LEFT JOIN russian_forks_april2019_count ON russian_watchers_april2019_count.repo_id = russian_forks_april2019_count.id
UNION ALL
SELECT * FROM russian_watchers_april2019_count
RIGHT JOIN russian_forks_april2019_count ON russian_watchers_april2019_count.repo_id = russian_forks_april2019_count.id
WHERE russian_watchers_april2019_count.repo_id IS NULL;
UPDATE russian_projects_influence_april2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE russian_projects_influence_april2019
DROP COLUMN id;
ALTER TABLE russian_projects_influence_april2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE russian_projects_influence_april2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE russian_projects_influence_april2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE russian_projects_influence_april2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE russian_projects_influence_april2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM russian_watchers_april2019_count), fork_total = (SELECT SUM(fork_count) FROM russian_forks_april2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM russian_forks_april2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE russian_projects_influence_april2019
SET repo_name = (SELECT projects.name FROM projects WHERE russian_projects_influence_april2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE russian_projects_influence_april2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE russian_projects_influence_april2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE russian_projects_influence_april2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE russian_projects_influence_april2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE russian_projects_influence_april2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE russian_projects_influence_april2019.repo_id = projects.id);

CREATE TABLE russian_projects_influence_march2019
SELECT * FROM russian_watchers_march2019_count
LEFT JOIN russian_forks_march2019_count ON russian_watchers_march2019_count.repo_id = russian_forks_march2019_count.id
UNION ALL
SELECT * FROM russian_watchers_march2019_count
RIGHT JOIN russian_forks_march2019_count ON russian_watchers_march2019_count.repo_id = russian_forks_march2019_count.id
WHERE russian_watchers_march2019_count.repo_id IS NULL;
UPDATE russian_projects_influence_march2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE russian_projects_influence_march2019
DROP COLUMN id;
ALTER TABLE russian_projects_influence_march2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE russian_projects_influence_march2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE russian_projects_influence_march2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE russian_projects_influence_march2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE russian_projects_influence_march2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM russian_watchers_march2019_count), fork_total = (SELECT SUM(fork_count) FROM russian_forks_march2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM russian_forks_march2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE russian_projects_influence_march2019
SET repo_name = (SELECT projects.name FROM projects WHERE russian_projects_influence_march2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE russian_projects_influence_march2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE russian_projects_influence_march2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE russian_projects_influence_march2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE russian_projects_influence_march2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE russian_projects_influence_march2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE russian_projects_influence_march2019.repo_id = projects.id);

CREATE TABLE russian_projects_influence_february2019
SELECT * FROM russian_watchers_february2019_count
LEFT JOIN russian_forks_february2019_count ON russian_watchers_february2019_count.repo_id = russian_forks_february2019_count.id
UNION ALL
SELECT * FROM russian_watchers_february2019_count
RIGHT JOIN russian_forks_february2019_count ON russian_watchers_february2019_count.repo_id = russian_forks_february2019_count.id
WHERE russian_watchers_february2019_count.repo_id IS NULL;
UPDATE russian_projects_influence_february2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE russian_projects_influence_february2019
DROP COLUMN id;
ALTER TABLE russian_projects_influence_february2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE russian_projects_influence_february2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE russian_projects_influence_february2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE russian_projects_influence_february2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE russian_projects_influence_february2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM russian_watchers_february2019_count), fork_total = (SELECT SUM(fork_count) FROM russian_forks_february2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM russian_forks_february2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE russian_projects_influence_february2019
SET repo_name = (SELECT projects.name FROM projects WHERE russian_projects_influence_february2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE russian_projects_influence_february2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE russian_projects_influence_february2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE russian_projects_influence_february2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE russian_projects_influence_february2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE russian_projects_influence_february2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE russian_projects_influence_february2019.repo_id = projects.id);

CREATE TABLE russian_projects_influence_january2019
SELECT * FROM russian_watchers_january2019_count
LEFT JOIN russian_forks_january2019_count ON russian_watchers_january2019_count.repo_id = russian_forks_january2019_count.id
UNION ALL
SELECT * FROM russian_watchers_january2019_count
RIGHT JOIN russian_forks_january2019_count ON russian_watchers_january2019_count.repo_id = russian_forks_january2019_count.id
WHERE russian_watchers_january2019_count.repo_id IS NULL;
UPDATE russian_projects_influence_january2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE russian_projects_influence_january2019
DROP COLUMN id;
ALTER TABLE russian_projects_influence_january2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE russian_projects_influence_january2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE russian_projects_influence_january2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE russian_projects_influence_january2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE russian_projects_influence_january2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM russian_watchers_january2019_count), fork_total = (SELECT SUM(fork_count) FROM russian_forks_january2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM russian_forks_january2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE russian_projects_influence_january2019
SET repo_name = (SELECT projects.name FROM projects WHERE russian_projects_influence_january2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE russian_projects_influence_january2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE russian_projects_influence_january2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE russian_projects_influence_january2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE russian_projects_influence_january2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE russian_projects_influence_january2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE russian_projects_influence_january2019.repo_id = projects.id);

CREATE TABLE chinese_projects_influence_june2019
SELECT * FROM chinese_watchers_june2019_count
LEFT JOIN chinese_forks_june2019_count ON chinese_watchers_june2019_count.repo_id = chinese_forks_june2019_count.id
UNION ALL
SELECT * FROM chinese_watchers_june2019_count
RIGHT JOIN chinese_forks_june2019_count ON chinese_watchers_june2019_count.repo_id = chinese_forks_june2019_count.id
WHERE chinese_watchers_june2019_count.repo_id IS NULL;
UPDATE chinese_projects_influence_june2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE chinese_projects_influence_june2019
DROP COLUMN id;
ALTER TABLE chinese_projects_influence_june2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE chinese_projects_influence_june2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE chinese_projects_influence_june2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE chinese_projects_influence_june2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE chinese_projects_influence_june2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM chinese_watchers_june2019_count), fork_total = (SELECT SUM(fork_count) FROM chinese_forks_june2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM chinese_forks_june2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE chinese_projects_influence_june2019
SET repo_name = (SELECT projects.name FROM projects WHERE chinese_projects_influence_june2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE chinese_projects_influence_june2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE chinese_projects_influence_june2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE chinese_projects_influence_june2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE chinese_projects_influence_june2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE chinese_projects_influence_june2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE chinese_projects_influence_june2019.repo_id = projects.id);

CREATE TABLE chinese_projects_influence_may2019
SELECT * FROM chinese_watchers_may2019_count
LEFT JOIN chinese_forks_may2019_count ON chinese_watchers_may2019_count.repo_id = chinese_forks_may2019_count.id
UNION ALL
SELECT * FROM chinese_watchers_may2019_count
RIGHT JOIN chinese_forks_may2019_count ON chinese_watchers_may2019_count.repo_id = chinese_forks_may2019_count.id
WHERE chinese_watchers_may2019_count.repo_id IS NULL;
UPDATE chinese_projects_influence_may2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE chinese_projects_influence_may2019
DROP COLUMN id;
ALTER TABLE chinese_projects_influence_may2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE chinese_projects_influence_may2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE chinese_projects_influence_may2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE chinese_projects_influence_may2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE chinese_projects_influence_may2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM chinese_watchers_may2019_count), fork_total = (SELECT SUM(fork_count) FROM chinese_forks_may2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM chinese_forks_may2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE chinese_projects_influence_may2019
SET repo_name = (SELECT projects.name FROM projects WHERE chinese_projects_influence_may2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE chinese_projects_influence_may2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE chinese_projects_influence_may2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE chinese_projects_influence_may2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE chinese_projects_influence_may2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE chinese_projects_influence_may2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE chinese_projects_influence_may2019.repo_id = projects.id);

CREATE TABLE chinese_projects_influence_april2019
SELECT * FROM chinese_watchers_april2019_count
LEFT JOIN chinese_forks_april2019_count ON chinese_watchers_april2019_count.repo_id = chinese_forks_april2019_count.id
UNION ALL
SELECT * FROM chinese_watchers_april2019_count
RIGHT JOIN chinese_forks_april2019_count ON chinese_watchers_april2019_count.repo_id = chinese_forks_april2019_count.id
WHERE chinese_watchers_april2019_count.repo_id IS NULL;
UPDATE chinese_projects_influence_april2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE chinese_projects_influence_april2019
DROP COLUMN id;
ALTER TABLE chinese_projects_influence_april2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE chinese_projects_influence_april2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE chinese_projects_influence_april2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE chinese_projects_influence_april2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE chinese_projects_influence_april2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM chinese_watchers_april2019_count), fork_total = (SELECT SUM(fork_count) FROM chinese_forks_april2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM chinese_forks_april2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE chinese_projects_influence_april2019
SET repo_name = (SELECT projects.name FROM projects WHERE chinese_projects_influence_april2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE chinese_projects_influence_april2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE chinese_projects_influence_april2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE chinese_projects_influence_april2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE chinese_projects_influence_april2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE chinese_projects_influence_april2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE chinese_projects_influence_april2019.repo_id = projects.id);

CREATE TABLE chinese_projects_influence_march2019
SELECT * FROM chinese_watchers_march2019_count
LEFT JOIN chinese_forks_march2019_count ON chinese_watchers_march2019_count.repo_id = chinese_forks_march2019_count.id
UNION ALL
SELECT * FROM chinese_watchers_march2019_count
RIGHT JOIN chinese_forks_march2019_count ON chinese_watchers_march2019_count.repo_id = chinese_forks_march2019_count.id
WHERE chinese_watchers_march2019_count.repo_id IS NULL;
UPDATE chinese_projects_influence_march2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE chinese_projects_influence_march2019
DROP COLUMN id;
ALTER TABLE chinese_projects_influence_march2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE chinese_projects_influence_march2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE chinese_projects_influence_march2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE chinese_projects_influence_march2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE chinese_projects_influence_march2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM chinese_watchers_march2019_count), fork_total = (SELECT SUM(fork_count) FROM chinese_forks_march2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM chinese_forks_march2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE chinese_projects_influence_march2019
SET repo_name = (SELECT projects.name FROM projects WHERE chinese_projects_influence_march2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE chinese_projects_influence_march2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE chinese_projects_influence_march2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE chinese_projects_influence_march2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE chinese_projects_influence_march2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE chinese_projects_influence_march2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE chinese_projects_influence_march2019.repo_id = projects.id);

CREATE TABLE chinese_projects_influence_february2019
SELECT * FROM chinese_watchers_february2019_count
LEFT JOIN chinese_forks_february2019_count ON chinese_watchers_february2019_count.repo_id = chinese_forks_february2019_count.id
UNION ALL
SELECT * FROM chinese_watchers_february2019_count
RIGHT JOIN chinese_forks_february2019_count ON chinese_watchers_february2019_count.repo_id = chinese_forks_february2019_count.id
WHERE chinese_watchers_february2019_count.repo_id IS NULL;
UPDATE chinese_projects_influence_february2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE chinese_projects_influence_february2019
DROP COLUMN id;
ALTER TABLE chinese_projects_influence_february2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE chinese_projects_influence_february2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE chinese_projects_influence_february2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE chinese_projects_influence_february2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE chinese_projects_influence_february2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM chinese_watchers_february2019_count), fork_total = (SELECT SUM(fork_count) FROM chinese_forks_february2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM chinese_forks_february2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE chinese_projects_influence_february2019
SET repo_name = (SELECT projects.name FROM projects WHERE chinese_projects_influence_february2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE chinese_projects_influence_february2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE chinese_projects_influence_february2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE chinese_projects_influence_february2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE chinese_projects_influence_february2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE chinese_projects_influence_february2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE chinese_projects_influence_february2019.repo_id = projects.id);

CREATE TABLE chinese_projects_influence_january2019
SELECT * FROM chinese_watchers_january2019_count
LEFT JOIN chinese_forks_january2019_count ON chinese_watchers_january2019_count.repo_id = chinese_forks_january2019_count.id
UNION ALL
SELECT * FROM chinese_watchers_january2019_count
RIGHT JOIN chinese_forks_january2019_count ON chinese_watchers_january2019_count.repo_id = chinese_forks_january2019_count.id
WHERE chinese_watchers_january2019_count.repo_id IS NULL;
UPDATE chinese_projects_influence_january2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE chinese_projects_influence_january2019
DROP COLUMN id;
ALTER TABLE chinese_projects_influence_january2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE chinese_projects_influence_january2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE chinese_projects_influence_january2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE chinese_projects_influence_january2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE chinese_projects_influence_january2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM chinese_watchers_january2019_count), fork_total = (SELECT SUM(fork_count) FROM chinese_forks_january2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM chinese_forks_january2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE chinese_projects_influence_january2019
SET repo_name = (SELECT projects.name FROM projects WHERE chinese_projects_influence_january2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE chinese_projects_influence_january2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE chinese_projects_influence_january2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE chinese_projects_influence_january2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE chinese_projects_influence_january2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE chinese_projects_influence_january2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE chinese_projects_influence_january2019.repo_id = projects.id);

CREATE TABLE unitedstates_projects_influence_june2019
SELECT * FROM unitedstates_watchers_june2019_count
LEFT JOIN unitedstates_forks_june2019_count ON unitedstates_watchers_june2019_count.repo_id = unitedstates_forks_june2019_count.id
UNION ALL
SELECT * FROM unitedstates_watchers_june2019_count
RIGHT JOIN unitedstates_forks_june2019_count ON unitedstates_watchers_june2019_count.repo_id = unitedstates_forks_june2019_count.id
WHERE unitedstates_watchers_june2019_count.repo_id IS NULL;
UPDATE unitedstates_projects_influence_june2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE unitedstates_projects_influence_june2019
DROP COLUMN id;
ALTER TABLE unitedstates_projects_influence_june2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE unitedstates_projects_influence_june2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE unitedstates_projects_influence_june2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE unitedstates_projects_influence_june2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE unitedstates_projects_influence_june2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM unitedstates_watchers_june2019_count), fork_total = (SELECT SUM(fork_count) FROM unitedstates_forks_june2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM unitedstates_forks_june2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE unitedstates_projects_influence_june2019
SET repo_name = (SELECT projects.name FROM projects WHERE unitedstates_projects_influence_june2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE unitedstates_projects_influence_june2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE unitedstates_projects_influence_june2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE unitedstates_projects_influence_june2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE unitedstates_projects_influence_june2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE unitedstates_projects_influence_june2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE unitedstates_projects_influence_june2019.repo_id = projects.id);

CREATE TABLE unitedstates_projects_influence_may2019
SELECT * FROM unitedstates_watchers_may2019_count
LEFT JOIN unitedstates_forks_may2019_count ON unitedstates_watchers_may2019_count.repo_id = unitedstates_forks_may2019_count.id
UNION ALL
SELECT * FROM unitedstates_watchers_may2019_count
RIGHT JOIN unitedstates_forks_may2019_count ON unitedstates_watchers_may2019_count.repo_id = unitedstates_forks_may2019_count.id
WHERE unitedstates_watchers_may2019_count.repo_id IS NULL;
UPDATE unitedstates_projects_influence_may2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE unitedstates_projects_influence_may2019
DROP COLUMN id;
ALTER TABLE unitedstates_projects_influence_may2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE unitedstates_projects_influence_may2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE unitedstates_projects_influence_may2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE unitedstates_projects_influence_may2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE unitedstates_projects_influence_may2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM unitedstates_watchers_may2019_count), fork_total = (SELECT SUM(fork_count) FROM unitedstates_forks_may2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM unitedstates_forks_may2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE unitedstates_projects_influence_may2019
SET repo_name = (SELECT projects.name FROM projects WHERE unitedstates_projects_influence_may2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE unitedstates_projects_influence_may2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE unitedstates_projects_influence_may2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE unitedstates_projects_influence_may2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE unitedstates_projects_influence_may2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE unitedstates_projects_influence_may2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE unitedstates_projects_influence_may2019.repo_id = projects.id);

CREATE TABLE unitedstates_projects_influence_april2019
SELECT * FROM unitedstates_watchers_april2019_count
LEFT JOIN unitedstates_forks_april2019_count ON unitedstates_watchers_april2019_count.repo_id = unitedstates_forks_april2019_count.id
UNION ALL
SELECT * FROM unitedstates_watchers_april2019_count
RIGHT JOIN unitedstates_forks_april2019_count ON unitedstates_watchers_april2019_count.repo_id = unitedstates_forks_april2019_count.id
WHERE unitedstates_watchers_april2019_count.repo_id IS NULL;
UPDATE unitedstates_projects_influence_april2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE unitedstates_projects_influence_april2019
DROP COLUMN id;
ALTER TABLE unitedstates_projects_influence_april2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE unitedstates_projects_influence_april2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE unitedstates_projects_influence_april2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE unitedstates_projects_influence_april2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE unitedstates_projects_influence_april2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM unitedstates_watchers_april2019_count), fork_total = (SELECT SUM(fork_count) FROM unitedstates_forks_april2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM unitedstates_forks_april2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE unitedstates_projects_influence_april2019
SET repo_name = (SELECT projects.name FROM projects WHERE unitedstates_projects_influence_april2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE unitedstates_projects_influence_april2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE unitedstates_projects_influence_april2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE unitedstates_projects_influence_april2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE unitedstates_projects_influence_april2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE unitedstates_projects_influence_april2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE unitedstates_projects_influence_april2019.repo_id = projects.id);

CREATE TABLE unitedstates_projects_influence_march2019
SELECT * FROM unitedstates_watchers_march2019_count
LEFT JOIN unitedstates_forks_march2019_count ON unitedstates_watchers_march2019_count.repo_id = unitedstates_forks_march2019_count.id
UNION ALL
SELECT * FROM unitedstates_watchers_march2019_count
RIGHT JOIN unitedstates_forks_march2019_count ON unitedstates_watchers_march2019_count.repo_id = unitedstates_forks_march2019_count.id
WHERE unitedstates_watchers_march2019_count.repo_id IS NULL;
UPDATE unitedstates_projects_influence_march2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE unitedstates_projects_influence_march2019
DROP COLUMN id;
ALTER TABLE unitedstates_projects_influence_march2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE unitedstates_projects_influence_march2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE unitedstates_projects_influence_march2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE unitedstates_projects_influence_march2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE unitedstates_projects_influence_march2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM unitedstates_watchers_march2019_count), fork_total = (SELECT SUM(fork_count) FROM unitedstates_forks_march2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM unitedstates_forks_march2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE unitedstates_projects_influence_march2019
SET repo_name = (SELECT projects.name FROM projects WHERE unitedstates_projects_influence_march2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE unitedstates_projects_influence_march2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE unitedstates_projects_influence_march2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE unitedstates_projects_influence_march2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE unitedstates_projects_influence_march2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE unitedstates_projects_influence_march2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE unitedstates_projects_influence_march2019.repo_id = projects.id);

CREATE TABLE unitedstates_projects_influence_february2019
SELECT * FROM unitedstates_watchers_february2019_count
LEFT JOIN unitedstates_forks_february2019_count ON unitedstates_watchers_february2019_count.repo_id = unitedstates_forks_february2019_count.id
UNION ALL
SELECT * FROM unitedstates_watchers_february2019_count
RIGHT JOIN unitedstates_forks_february2019_count ON unitedstates_watchers_february2019_count.repo_id = unitedstates_forks_february2019_count.id
WHERE unitedstates_watchers_february2019_count.repo_id IS NULL;
UPDATE unitedstates_projects_influence_february2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE unitedstates_projects_influence_february2019
DROP COLUMN id;
ALTER TABLE unitedstates_projects_influence_february2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE unitedstates_projects_influence_february2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE unitedstates_projects_influence_february2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE unitedstates_projects_influence_february2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE unitedstates_projects_influence_february2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM unitedstates_watchers_february2019_count), fork_total = (SELECT SUM(fork_count) FROM unitedstates_forks_february2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM unitedstates_forks_february2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE unitedstates_projects_influence_february2019
SET repo_name = (SELECT projects.name FROM projects WHERE unitedstates_projects_influence_february2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE unitedstates_projects_influence_february2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE unitedstates_projects_influence_february2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE unitedstates_projects_influence_february2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE unitedstates_projects_influence_february2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE unitedstates_projects_influence_february2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE unitedstates_projects_influence_february2019.repo_id = projects.id);

CREATE TABLE unitedstates_projects_influence_january2019
SELECT * FROM unitedstates_watchers_january2019_count
LEFT JOIN unitedstates_forks_january2019_count ON unitedstates_watchers_january2019_count.repo_id = unitedstates_forks_january2019_count.id
UNION ALL
SELECT * FROM unitedstates_watchers_january2019_count
RIGHT JOIN unitedstates_forks_january2019_count ON unitedstates_watchers_january2019_count.repo_id = unitedstates_forks_january2019_count.id
WHERE unitedstates_watchers_january2019_count.repo_id IS NULL;
UPDATE unitedstates_projects_influence_january2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE unitedstates_projects_influence_january2019
DROP COLUMN id;
ALTER TABLE unitedstates_projects_influence_january2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE unitedstates_projects_influence_january2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE unitedstates_projects_influence_january2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE unitedstates_projects_influence_january2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE unitedstates_projects_influence_january2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM unitedstates_watchers_january2019_count), fork_total = (SELECT SUM(fork_count) FROM unitedstates_forks_january2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM unitedstates_forks_january2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE unitedstates_projects_influence_january2019
SET repo_name = (SELECT projects.name FROM projects WHERE unitedstates_projects_influence_january2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE unitedstates_projects_influence_january2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE unitedstates_projects_influence_january2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE unitedstates_projects_influence_january2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE unitedstates_projects_influence_january2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE unitedstates_projects_influence_january2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE unitedstates_projects_influence_january2019.repo_id = projects.id);

CREATE TABLE indian_projects_influence_june2019
SELECT * FROM indian_watchers_june2019_count
LEFT JOIN indian_forks_june2019_count ON indian_watchers_june2019_count.repo_id = indian_forks_june2019_count.id
UNION ALL
SELECT * FROM indian_watchers_june2019_count
RIGHT JOIN indian_forks_june2019_count ON indian_watchers_june2019_count.repo_id = indian_forks_june2019_count.id
WHERE indian_watchers_june2019_count.repo_id IS NULL;
UPDATE indian_projects_influence_june2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE indian_projects_influence_june2019
DROP COLUMN id;
ALTER TABLE indian_projects_influence_june2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE indian_projects_influence_june2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE indian_projects_influence_june2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE indian_projects_influence_june2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE indian_projects_influence_june2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM indian_watchers_june2019_count), fork_total = (SELECT SUM(fork_count) FROM indian_forks_june2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM indian_forks_june2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE indian_projects_influence_june2019
SET repo_name = (SELECT projects.name FROM projects WHERE indian_projects_influence_june2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE indian_projects_influence_june2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE indian_projects_influence_june2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE indian_projects_influence_june2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE indian_projects_influence_june2019.owner_id = users.id), 
code_language = (SELECT projects.language FROM projects WHERE indian_projects_influence_june2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE indian_projects_influence_june2019.repo_id = projects.id);

CREATE TABLE indian_projects_influence_may2019
SELECT * FROM indian_watchers_may2019_count
LEFT JOIN indian_forks_may2019_count ON indian_watchers_may2019_count.repo_id = indian_forks_may2019_count.id
UNION ALL
SELECT * FROM indian_watchers_may2019_count
RIGHT JOIN indian_forks_may2019_count ON indian_watchers_may2019_count.repo_id = indian_forks_may2019_count.id
WHERE indian_watchers_may2019_count.repo_id IS NULL;
UPDATE indian_projects_influence_may2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE indian_projects_influence_may2019
DROP COLUMN id;
ALTER TABLE indian_projects_influence_may2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE indian_projects_influence_may2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE indian_projects_influence_may2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE indian_projects_influence_may2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE indian_projects_influence_may2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM indian_watchers_may2019_count), fork_total = (SELECT SUM(fork_count) FROM indian_forks_may2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM indian_forks_may2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE indian_projects_influence_may2019
SET repo_name = (SELECT projects.name FROM projects WHERE indian_projects_influence_may2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE indian_projects_influence_may2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE indian_projects_influence_may2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE indian_projects_influence_may2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE indian_projects_influence_may2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE indian_projects_influence_may2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE indian_projects_influence_may2019.repo_id = projects.id);

CREATE TABLE indian_projects_influence_april2019
SELECT * FROM indian_watchers_april2019_count
LEFT JOIN indian_forks_april2019_count ON indian_watchers_april2019_count.repo_id = indian_forks_april2019_count.id
UNION ALL
SELECT * FROM indian_watchers_april2019_count
RIGHT JOIN indian_forks_april2019_count ON indian_watchers_april2019_count.repo_id = indian_forks_april2019_count.id
WHERE indian_watchers_april2019_count.repo_id IS NULL;
UPDATE indian_projects_influence_april2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE indian_projects_influence_april2019
DROP COLUMN id;
ALTER TABLE indian_projects_influence_april2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE indian_projects_influence_april2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE indian_projects_influence_april2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE indian_projects_influence_april2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE indian_projects_influence_april2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM indian_watchers_april2019_count), fork_total = (SELECT SUM(fork_count) FROM indian_forks_april2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM indian_forks_april2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE indian_projects_influence_april2019
SET repo_name = (SELECT projects.name FROM projects WHERE indian_projects_influence_april2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE indian_projects_influence_april2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE indian_projects_influence_april2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE indian_projects_influence_april2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE indian_projects_influence_april2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE indian_projects_influence_april2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE indian_projects_influence_april2019.repo_id = projects.id);

CREATE TABLE indian_projects_influence_march2019
SELECT * FROM indian_watchers_march2019_count
LEFT JOIN indian_forks_march2019_count ON indian_watchers_march2019_count.repo_id = indian_forks_march2019_count.id
UNION ALL
SELECT * FROM indian_watchers_march2019_count
RIGHT JOIN indian_forks_march2019_count ON indian_watchers_march2019_count.repo_id = indian_forks_march2019_count.id
WHERE indian_watchers_march2019_count.repo_id IS NULL;
UPDATE indian_projects_influence_march2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE indian_projects_influence_march2019
DROP COLUMN id;
ALTER TABLE indian_projects_influence_march2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE indian_projects_influence_march2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE indian_projects_influence_march2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE indian_projects_influence_march2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE indian_projects_influence_march2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM indian_watchers_march2019_count), fork_total = (SELECT SUM(fork_count) FROM indian_forks_march2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM indian_forks_march2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE indian_projects_influence_march2019
SET repo_name = (SELECT projects.name FROM projects WHERE indian_projects_influence_march2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE indian_projects_influence_march2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE indian_projects_influence_march2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE indian_projects_influence_march2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE indian_projects_influence_march2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE indian_projects_influence_march2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE indian_projects_influence_march2019.repo_id = projects.id);

CREATE TABLE indian_projects_influence_february2019
SELECT * FROM indian_watchers_february2019_count
LEFT JOIN indian_forks_february2019_count ON indian_watchers_february2019_count.repo_id = indian_forks_february2019_count.id
UNION ALL
SELECT * FROM indian_watchers_february2019_count
RIGHT JOIN indian_forks_february2019_count ON indian_watchers_february2019_count.repo_id = indian_forks_february2019_count.id
WHERE indian_watchers_february2019_count.repo_id IS NULL;
UPDATE indian_projects_influence_february2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE indian_projects_influence_february2019
DROP COLUMN id;
ALTER TABLE indian_projects_influence_february2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE indian_projects_influence_february2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE indian_projects_influence_february2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE indian_projects_influence_february2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE indian_projects_influence_february2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM indian_watchers_february2019_count), fork_total = (SELECT SUM(fork_count) FROM indian_forks_february2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM indian_forks_february2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE indian_projects_influence_february2019
SET repo_name = (SELECT projects.name FROM projects WHERE indian_projects_influence_february2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE indian_projects_influence_february2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE indian_projects_influence_february2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE indian_projects_influence_february2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE indian_projects_influence_february2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE indian_projects_influence_february2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE indian_projects_influence_february2019.repo_id = projects.id);

CREATE TABLE indian_projects_influence_january2019
SELECT * FROM indian_watchers_january2019_count
LEFT JOIN indian_forks_january2019_count ON indian_watchers_january2019_count.repo_id = indian_forks_january2019_count.id
UNION ALL
SELECT * FROM indian_watchers_january2019_count
RIGHT JOIN indian_forks_january2019_count ON indian_watchers_january2019_count.repo_id = indian_forks_january2019_count.id
WHERE indian_watchers_january2019_count.repo_id IS NULL;
UPDATE indian_projects_influence_january2019
SET repo_id = id
WHERE repo_id IS NULL;
ALTER TABLE indian_projects_influence_january2019
DROP COLUMN id;
ALTER TABLE indian_projects_influence_january2019
ADD(influence_count BIGINT(21), weighted_influence_count FLOAT(21), star_total BIGINT(21), 
fork_total BIGINT(21), weighted_fork_total FLOAT(21), influence_total BIGINT(21), weighted_influence_total FLOAT(21), 
influence_score FLOAT(21), weighted_influence_score FLOAT(21), repo_name VARCHAR(255), description VARCHAR(255), url VARCHAR(255), 
owner_id INT(11), owner_name VARCHAR(255), code_language VARCHAR(255), forked_from INT(11));
UPDATE indian_projects_influence_january2019
SET star_count = 0
WHERE star_count IS NULL; 
UPDATE indian_projects_influence_january2019
SET fork_count = 0
WHERE fork_count IS NULL;
UPDATE indian_projects_influence_january2019
SET weighted_fork_count = 0
WHERE weighted_fork_count IS NULL;  
UPDATE indian_projects_influence_january2019
SET influence_count = (star_count + fork_count), weighted_influence_count = (star_count + weighted_fork_count),
star_total = (SELECT SUM(star_count) FROM indian_watchers_january2019_count), fork_total = (SELECT SUM(fork_count) FROM indian_forks_january2019_count), 
weighted_fork_total = (SELECT SUM(weighted_fork_count) FROM indian_forks_january2019_count), influence_total = (star_total + fork_total), 
weighted_influence_total = (star_total + weighted_fork_total), influence_score = (influence_count / influence_total), 
weighted_influence_score = (weighted_influence_count / weighted_influence_total);
UPDATE indian_projects_influence_january2019
SET repo_name = (SELECT projects.name FROM projects WHERE indian_projects_influence_january2019.repo_id = projects.id), 
description = (SELECT projects.description FROM projects WHERE indian_projects_influence_january2019.repo_id = projects.id),
url = (SELECT projects.url FROM projects WHERE indian_projects_influence_january2019.repo_id = projects.id), 
owner_id = (SELECT projects.owner_id FROM projects WHERE indian_projects_influence_january2019.repo_id = projects.id),
owner_name = (SELECT users.login FROM users WHERE indian_projects_influence_january2019.owner_id = users.id),  
code_language = (SELECT projects.language FROM projects WHERE indian_projects_influence_january2019.repo_id = projects.id), 
forked_from = (SELECT projects.forked_from FROM projects WHERE indian_projects_influence_january2019.repo_id = projects.id);
/* Create Clean User Table for Analysis
/* Code blocks to create a clean user tables (with only u.follow, u.watch, and u.fork data) for creating histograms. */

CREATE TABLE russian_users_simple
SELECT id AS user_id, login, follower_count, russian_follower_count, fork_count, russian_fork_count, watcher_count, russian_watcher_count
FROM ghtorrent_restore.russian_users;

CREATE TABLE chinese_users_simple
SELECT id AS user_id, login, follower_count, chinese_follower_count, fork_count, chinese_fork_count, watcher_count, chinese_watcher_count
FROM ghtorrent_restore.chinese_users;

CREATE TABLE unitedstates_users_simple
SELECT id AS user_id, login, follower_count, unitedstates_follower_count, fork_count, unitedstates_fork_count, watcher_count, unitedstates_watcher_count
FROM ghtorrent_restore.unitedstates_users;

CREATE TABLE indian_users_simple
SELECT id AS user_id, login, follower_count, indian_follower_count, fork_count, indian_fork_count, watcher_count, indian_watcher_count
FROM ghtorrent_restore.indian_users;
/* Create Six-month Repository Star Tables for Analysis */
/*Code blocks to create the tables used to export data for use in the Appendix B Python code that creates histograms for analyzing the repository watching activity of the nation groups */

CREATE TABLE watchers_6_months
SELECT watchers.*
FROM watchers
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-06-01' AS DATE);
CREATE INDEX repo_id ON watchers_6_months (repo_id);
CREATE INDEX user_id ON watchers_6_months (user_id);

CREATE TABLE russian_watchers_6_months
SELECT watchers_6_months.*
FROM watchers_6_months, russian_users
WHERE watchers_6_months.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_watchers_6_months (repo_id);
CREATE INDEX user_id ON russian_watchers_6_months (user_id);

CREATE TABLE chinese_watchers_6_months
SELECT watchers_6_months.*
FROM watchers_6_months, chinese_users
WHERE watchers_6_months.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_watchers_6_months (repo_id);
CREATE INDEX user_id ON chinese_watchers_6_months (user_id);

CREATE TABLE unitedstates_watchers_6_months
SELECT watchers_6_months.*
FROM watchers_6_months, unitedstates_users
WHERE watchers_6_months.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_watchers_6_months (repo_id);
CREATE INDEX user_id ON unitedstates_watchers_6_months (user_id);

CREATE TABLE indian_watchers_6_months
SELECT watchers_6_months.*
FROM watchers_6_months, indian_users
WHERE watchers_6_months.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_watchers_6_months (repo_id);
CREATE INDEX user_id ON indian_watchers_6_months (user_id);

/* Code blocks to create the raw count tables */

CREATE TABLE watchers_6_months_count
SELECT watchers_6_months.user_id, COUNT(*) AS star_count
FROM watchers_6_months
GROUP BY watchers_6_months.user_id;
CREATE INDEX user_id ON watchers_6_months_count(user_id);

CREATE TABLE russian_watchers_6_months_count
SELECT russian_watchers_6_months.user_id, COUNT(*) AS star_count
FROM russian_watchers_6_months
GROUP BY russian_watchers_6_months.user_id;
CREATE INDEX user_id ON russian_watchers_6_months_count(user_id);

CREATE TABLE chinese_watchers_6_months_count
SELECT chinese_watchers_6_months.user_id, COUNT(*) AS star_count
FROM chinese_watchers_6_months
GROUP BY chinese_watchers_6_months.user_id;
CREATE INDEX user_id ON chinese_watchers_6_months_count(user_id);

CREATE TABLE unitedstates_watchers_6_months_count
SELECT unitedstates_watchers_6_months.user_id, COUNT(*) AS star_count
FROM unitedstates_watchers_6_months
GROUP BY unitedstates_watchers_6_months.user_id;
CREATE INDEX user_id ON unitedstates_watchers_6_months_count(user_id);

CREATE TABLE indian_watchers_6_months_count
SELECT indian_watchers_6_months.user_id, COUNT(*) AS star_count
FROM indian_watchers_6_months
GROUP BY indian_watchers_6_months.user_id;
CREATE INDEX user_id ON indian_watchers_6_months_count(user_id);

/* Code blocks to include users with 0 stars for the six-month period */

CREATE TABLE watchers_6_months_all
SELECT users.id AS user_id, watchers_6_months_count.star_count
FROM users
LEFT JOIN watchers_6_months_count ON users.id = watchers_6_months_count.user_id;
CREATE INDEX user_id ON watchers_6_months_all (user_id);
UPDATE watchers_6_months_all
SET star_count = 0
WHERE star_count IS NULL;

CREATE TABLE russian_watchers_6_months_all
SELECT russian_users.id AS user_id, russian_watchers_6_months_count.star_count
FROM russian_users
LEFT JOIN russian_watchers_6_months_count ON russian_users.id = russian_watchers_6_months_count.user_id;
CREATE INDEX user_id ON russian_watchers_6_months_all (user_id);
UPDATE russian_watchers_6_months_all
SET star_count = 0
WHERE star_count IS NULL;

CREATE TABLE chinese_watchers_6_months_all
SELECT chinese_users.id AS user_id, chinese_watchers_6_months_count.star_count
FROM chinese_users
LEFT JOIN chinese_watchers_6_months_count ON chinese_users.id = chinese_watchers_6_months_count.user_id;
CREATE INDEX user_id ON chinese_watchers_6_months_all (user_id);
UPDATE chinese_watchers_6_months_all
SET star_count = 0
WHERE star_count IS NULL;

CREATE TABLE unitedstates_watchers_6_months_all
SELECT unitedstates_users.id AS user_id, unitedstates_watchers_6_months_count.star_count
FROM unitedstates_users
LEFT JOIN unitedstates_watchers_6_months_count ON unitedstates_users.id = unitedstates_watchers_6_months_count.user_id;
CREATE INDEX user_id ON unitedstates_watchers_6_months_all (user_id);
UPDATE unitedstates_watchers_6_months_all
SET star_count = 0
WHERE star_count IS NULL;

CREATE TABLE indian_watchers_6_months_all
SELECT indian_users.id AS user_id, indian_watchers_6_months_count.star_count
FROM indian_users
LEFT JOIN indian_watchers_6_months_count ON indian_users.id = indian_watchers_6_months_count.user_id;
CREATE INDEX user_id ON indian_watchers_6_months_all (user_id);
UPDATE indian_watchers_6_months_all
SET star_count = 0
WHERE star_count IS NULL;
/* Create Six-month Repository Fork Tables for Analysis */
/* Creates the tables used to export data for use in the Appendix B Python code that creates histograms for analyzing the repository forking activity of the nation groups */

CREATE TABLE forks_6_months
SELECT projects.owner_id AS user_id, projects.id AS repo_id, projects.forked_from
FROM projects
WHERE created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-06-01' AS DATE);
CREATE INDEX repo_id ON forks_6_months (repo_id);
CREATE INDEX user_id ON forks_6_months (user_id);
DELETE FROM forks_6_months WHERE forked_from IS NULL;

CREATE TABLE russian_forks_6_months
SELECT forks_6_months.*
FROM forks_6_months, russian_users
WHERE forks_6_months.user_id = russian_users.id;
CREATE INDEX repo_id ON russian_forks_6_months (repo_id);
CREATE INDEX user_id ON russian_forks_6_months (user_id);

CREATE TABLE chinese_forks_6_months
SELECT forks_6_months.*
FROM forks_6_months, chinese_users
WHERE forks_6_months.user_id = chinese_users.id;
CREATE INDEX repo_id ON chinese_forks_6_months (repo_id);
CREATE INDEX user_id ON chinese_forks_6_months (user_id);

CREATE TABLE unitedstates_forks_6_months
SELECT forks_6_months.*
FROM forks_6_months, unitedstates_users
WHERE forks_6_months.user_id = unitedstates_users.id;
CREATE INDEX repo_id ON unitedstates_forks_6_months (repo_id);
CREATE INDEX user_id ON unitedstates_forks_6_months (user_id);

CREATE TABLE indian_forks_6_months
SELECT forks_6_months.*
FROM forks_6_months, indian_users
WHERE forks_6_months.user_id = indian_users.id;
CREATE INDEX repo_id ON indian_forks_6_months (repo_id);
CREATE INDEX user_id ON indian_forks_6_months (user_id);

/* Code blocks to create the raw count tables */

CREATE TABLE forks_6_months_count
SELECT forks_6_months.user_id, COUNT(*) AS fork_count
FROM forks_6_months
GROUP BY forks_6_months.user_id;
CREATE INDEX user_id ON forks_6_months_count(user_id);

CREATE TABLE russian_forks_6_months_count
SELECT russian_forks_6_months.user_id, COUNT(*) AS fork_count
FROM russian_forks_6_months
GROUP BY russian_forks_6_months.user_id;
CREATE INDEX user_id ON russian_forks_6_months_count(user_id);

CREATE TABLE chinese_forks_6_months_count
SELECT chinese_forks_6_months.user_id, COUNT(*) AS fork_count
FROM chinese_forks_6_months
GROUP BY chinese_forks_6_months.user_id;
CREATE INDEX user_id ON chinese_forks_6_months_count(user_id);

CREATE TABLE unitedstates_forks_6_months_count
SELECT unitedstates_forks_6_months.user_id, COUNT(*) AS fork_count
FROM unitedstates_forks_6_months
GROUP BY unitedstates_forks_6_months.user_id;
CREATE INDEX user_id ON unitedstates_forks_6_months_count(user_id);

CREATE TABLE indian_forks_6_months_count
SELECT indian_forks_6_months.user_id, COUNT(*) AS fork_count
FROM indian_forks_6_months
GROUP BY indian_forks_6_months.user_id;
CREATE INDEX user_id ON indian_forks_6_months_count(user_id);

/* Code blocks to include users with 0 forks for the six-month period */

CREATE TABLE forks_6_months_all
SELECT users.id AS user_id, forks_6_months_count.fork_count
FROM users
LEFT JOIN forks_6_months_count ON users.id = forks_6_months_count.user_id;
CREATE INDEX user_id ON forks_6_months_all (user_id);
UPDATE forks_6_months_all
SET fork_count = 0
WHERE fork_count IS NULL;

CREATE TABLE russian_forks_6_months_all
SELECT russian_users.id AS user_id, russian_forks_6_months_count.fork_count
FROM russian_users
LEFT JOIN russian_forks_6_months_count ON russian_users.id = russian_forks_6_months_count.user_id;
CREATE INDEX user_id ON russian_forks_6_months_all (user_id);
UPDATE russian_forks_6_months_all
SET fork_count = 0
WHERE fork_count IS NULL;

CREATE TABLE chinese_forks_6_months_all
SELECT chinese_users.id AS user_id, chinese_forks_6_months_count.fork_count
FROM chinese_users
LEFT JOIN chinese_forks_6_months_count ON chinese_users.id = chinese_forks_6_months_count.user_id;
CREATE INDEX user_id ON chinese_forks_6_months_all (user_id);
UPDATE chinese_forks_6_months_all
SET fork_count = 0
WHERE fork_count IS NULL;

CREATE TABLE unitedstates_forks_6_months_all
SELECT unitedstates_users.id AS user_id, unitedstates_forks_6_months_count.fork_count
FROM unitedstates_users
LEFT JOIN unitedstates_forks_6_months_count ON unitedstates_users.id = unitedstates_forks_6_months_count.user_id;
CREATE INDEX user_id ON unitedstates_forks_6_months_all (user_id);
UPDATE unitedstates_forks_6_months_all
SET fork_count = 0
WHERE fork_count IS NULL;

CREATE TABLE indian_forks_6_months_all
SELECT indian_users.id AS user_id, indian_forks_6_months_count.fork_count
FROM indian_users
LEFT JOIN indian_forks_6_months_count ON indian_users.id = indian_forks_6_months_count.user_id;
CREATE INDEX user_id ON indian_forks_6_months_all (user_id);
UPDATE indian_forks_6_months_all
SET fork_count = 0WHERE fork_count IS NULL;
/* Create Repository All-time Forks Given Tables for Analysis */
/*Code blocks to create the tables used to export data for use in the Appendix B Python code that creates histograms for analyzing the repository forking activity of the nation groups */

CREATE TABLE russian_forks_given
SELECT a.* 
FROM russian_projects a, russian_users b
WHERE a.owner_id = b.id
AND a.forked_from IS NOT NULL;
CREATE INDEX id ON russian_forks_given(id);
CREATE INDEX owner_id ON russian_forks_given(owner_id);

CREATE TABLE chinese_forks_given
SELECT a.* 
FROM chinese_projects a, chinese_users b
WHERE a.owner_id = b.id
AND a.forked_from IS NOT NULL;
CREATE INDEX id ON chinese_forks_given(id);
CREATE INDEX owner_id ON chinese_forks_given(owner_id);

CREATE TABLE unitedstates_forks_given
SELECT a.* 
FROM unitedstates_projects a, unitedstates_users b
WHERE a.owner_id = b.id
AND a.forked_from IS NOT NULL;
CREATE INDEX id ON unitedstates_forks_given(id);
CREATE INDEX owner_id ON unitedstates_forks_given(owner_id);

CREATE TABLE indian_forks_given
SELECT a.* 
FROM indian_projects a, indian_users b
WHERE a.owner_id = b.id
AND a.forked_from IS NOT NULL;
CREATE INDEX id ON indian_forks_given(id);
CREATE INDEX owner_id ON indian_forks_given(owner_id);

CREATE TABLE russian_forks_given_count
SELECT a.owner_id, COUNT(*) AS fork_count 
FROM russian_forks_given a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON russian_forks_given_count(owner_id);

CREATE TABLE chinese_forks_given_count
SELECT a.owner_id, COUNT(*) AS fork_count 
FROM chinese_forks_given a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON chinese_forks_given_count(owner_id);

CREATE TABLE unitedstates_forks_given_count
SELECT a.owner_id, COUNT(*) AS fork_count 
FROM unitedstates_forks_given a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON unitedstates_forks_given_count(owner_id);

CREATE TABLE indian_forks_given_count
SELECT a.owner_id, COUNT(*) AS fork_count 
FROM indian_forks_given a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON indian_forks_given_count(owner_id);
/* Create Repository All-time Stars Given Tables for Analysis */
/*Code blocks to create the tables used to export data for use in the Appendix B Python code that creates histograms for analyzing the repository watching activity of the nation groups */

CREATE TABLE russian_stars_given_count
SELECT a.user_id, COUNT(*) AS star_count 
FROM russian_watchers a
GROUP BY a.user_id;
CREATE INDEX user_id ON russian_stars_given_count(user_id);

CREATE TABLE chinese_stars_given_count
SELECT a.user_id, COUNT(*) AS star_count 
FROM chinese_watchers a
GROUP BY a.user_id;
CREATE INDEX user_id ON chinese_stars_given_count(user_id);

CREATE TABLE unitedstates_stars_given_count
SELECT a.user_id, COUNT(*) AS star_count 
FROM unitedstates_watchers a
GROUP BY a.user_id;
CREATE INDEX user_id ON unitedstates_stars_given_count(user_id);

CREATE TABLE indian_stars_given_count
SELECT a.user_id, COUNT(*) AS star_count 
FROM indian_watchers a
GROUP BY a.user_id;
CREATE INDEX user_id ON indian_stars_given_count(user_id);
/* Create Six-Month User Forks Received Tables for Analysis */
/*Code blocks to create the tables used to export data for use in the Appendix B Python code that creates histograms for analyzing the repository forking activity of the nation groups */

CREATE TABLE projects_6_months
SELECT * FROM projects
WHERE projects.created_at BETWEEN CAST('2018-12-02' AS DATE) AND CAST('2019-06-01' AS DATE);
CREATE INDEX id ON projects_6_months(id);
CREATE INDEX owner_id ON projects_6_months(owner_id);
CREATE INDEX forked_from ON projects_6_months(forked_from);

CREATE TABLE russian_forks_received_6_months
SELECT a.* 
FROM projects_6_months a, russian_projects b
WHERE a.forked_from = b.id;
CREATE INDEX id ON russian_forks_received_6_months(id);
CREATE INDEX owner_id ON russian_forks_received_6_months(owner_id);
CREATE INDEX forked_from ON russian_forks_received_6_months(forked_from);
ALTER TABLE russian_forks_received_6_months
ADD(user_id BIGINT(21));
UPDATE russian_forks_received_6_months
SET user_id = (SELECT russian_projects.owner_id FROM russian_projects 
WHERE russian_forks_received_6_months.forked_from = russian_projects.id);  

CREATE TABLE chinese_forks_received_6_months
SELECT a.* 
FROM projects_6_months a, chinese_projects b
WHERE a.forked_from = b.id;
CREATE INDEX id ON chinese_forks_received_6_months(id);
CREATE INDEX owner_id ON chinese_forks_received_6_months(owner_id);
CREATE INDEX forked_from ON chinese_forks_received_6_months(forked_from);
ALTER TABLE chinese_forks_received_6_months
ADD(user_id BIGINT(21));
UPDATE chinese_forks_received_6_months
SET user_id = (SELECT chinese_projects.owner_id FROM chinese_projects 
WHERE chinese_forks_received_6_months.forked_from = chinese_projects.id);  

CREATE TABLE unitedstates_forks_received_6_months
SELECT a.* 
FROM projects_6_months a, unitedstates_projects b
WHERE a.forked_from = b.id;
CREATE INDEX id ON unitedstates_forks_received_6_months(id);
CREATE INDEX owner_id ON unitedstates_forks_received_6_months(owner_id);
CREATE INDEX forked_from ON unitedstates_forks_received_6_months(forked_from);
ALTER TABLE unitedstates_forks_received_6_months
ADD(user_id BIGINT(21));
UPDATE unitedstates_forks_received_6_months
SET user_id = (SELECT unitedstates_projects.owner_id FROM unitedstates_projects 
WHERE unitedstates_forks_received_6_months.forked_from = unitedstates_projects.id);  

CREATE TABLE indian_forks_received_6_months
SELECT a.* 
FROM projects_6_months a, indian_projects b
WHERE a.forked_from = b.id;
CREATE INDEX id ON indian_forks_received_6_months(id);
CREATE INDEX owner_id ON indian_forks_received_6_months(owner_id);
CREATE INDEX forked_from ON indian_forks_received_6_months(forked_from);
ALTER TABLE indian_forks_received_6_months
ADD(user_id BIGINT(21));
UPDATE indian_forks_received_6_months
SET user_id = (SELECT indian_projects.owner_id FROM indian_projects 
WHERE indian_forks_received_6_months.forked_from = indian_projects.id);

CREATE TABLE russian_forks_received_6_months_count
SELECT a.user_id, COUNT(*) AS fork_count 
FROM russian_forks_received_6_months a
GROUP BY a.user_id;
CREATE INDEX user_id ON russian_forks_received_6_months_count(user_id);

CREATE TABLE chinese_forks_received_6_months_count
SELECT a.user_id, COUNT(*) AS fork_count 
FROM chinese_forks_received_6_months a
GROUP BY a.user_id;
CREATE INDEX user_id ON chinese_forks_received_6_months_count(user_id);

CREATE TABLE unitedstates_forks_received_6_months_count
SELECT a.user_id, COUNT(*) AS fork_count 
FROM unitedstates_forks_received_6_months a
GROUP BY a.user_id;
CREATE INDEX user_id ON unitedstates_forks_received_6_months_count(user_id);

CREATE TABLE indian_forks_received_6_months_count
SELECT a.user_id, COUNT(*) AS fork_count 
FROM indian_forks_received_6_months a
GROUP BY a.user_id;
CREATE INDEX user_id ON indian_forks_received_6_months_count(user_id);  
/* Create Six-Month User Stars Received Tables for Analysis */
/*Code blocks to create the tables used to export data for use in the Appendix B Python code that creates histograms for analyzing the repository watching activity of the nation groups */

CREATE TABLE russian_stars_received_6_months
SELECT b.* 
FROM watchers_6_months a, russian_projects b
WHERE a.repo_id = b.id;
CREATE INDEX id ON russian_stars_received_6_months(id);
CREATE INDEX owner_id ON russian_stars_received_6_months(owner_id);
CREATE INDEX forked_from ON russian_stars_received_6_months(forked_from);

CREATE TABLE chinese_stars_received_6_months
SELECT b.* 
FROM watchers_6_months a, chinese_projects b
WHERE a.repo_id = b.id;
CREATE INDEX id ON chinese_stars_received_6_months(id);
CREATE INDEX owner_id ON chinese_stars_received_6_months(owner_id);
CREATE INDEX forked_from ON chinese_stars_received_6_months(forked_from);

CREATE TABLE unitedstates_stars_received_6_months
SELECT b.* 
FROM watchers_6_months a, unitedstates_projects b
WHERE a.repo_id = b.id;
CREATE INDEX id ON unitedstates_stars_received_6_months(id);
CREATE INDEX owner_id ON unitedstates_stars_received_6_months(owner_id);
CREATE INDEX forked_from ON unitedstates_stars_received_6_months(forked_from);

CREATE TABLE indian_stars_received_6_months
SELECT b.* 
FROM watchers_6_months a, indian_projects b
WHERE a.repo_id = b.id;
CREATE INDEX id ON indian_stars_received_6_months(id);
CREATE INDEX owner_id ON indian_stars_received_6_months(owner_id);
CREATE INDEX forked_from ON indian_stars_received_6_months(forked_from);
CREATE TABLE russian_stars_received_6_months_count
SELECT a.owner_id, COUNT(*) AS star_count 
FROM russian_stars_received_6_months a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON russian_stars_received_6_months_count(owner_id);

CREATE TABLE chinese_stars_received_6_months_count
SELECT a.owner_id, COUNT(*) AS star_count 
FROM chinese_stars_received_6_months a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON chinese_stars_received_6_months_count(owner_id);

CREATE TABLE unitedstates_stars_received_6_months_count
SELECT a.owner_id, COUNT(*) AS star_count 
FROM unitedstates_stars_received_6_months a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON unitedstates_stars_received_6_months_count(owner_id);

CREATE TABLE indian_stars_received_6_months_count
SELECT a.owner_id, COUNT(*) AS star_count 
FROM indian_stars_received_6_months a
GROUP BY a.owner_id;
CREATE INDEX owner_id ON indian_stars_received_6_months_count(owner_id);
/* Create Follows Given Tables for Analysis */ 
/*Code blocks to create the tables used to export data for use in the Appendix B Python code that creates histograms for analyzing the follower activity of the nation groups */

CREATE TABLE russian_follows_given
SELECT a.* 
FROM followers a, russian_users b
WHERE a.follower_id = b.id;
CREATE INDEX follower_id ON russian_follows_given(follower_id);
CREATE INDEX user_id ON russian_follows_given(user_id);

CREATE TABLE russian_follows_given_count
SELECT a.follower_id, COUNT(*) AS follows
FROM russian_follows_given a
GROUP BY a.follower_id;
CREATE INDEX follower_id ON russian_follows_given_count(follower_id);

CREATE TABLE chinese_follows_given
SELECT a.* 
FROM followers a, chinese_users b
WHERE a.follower_id = b.id;
CREATE INDEX follower_id ON chinese_follows_given(follower_id);
CREATE INDEX user_id ON chinese_follows_given(user_id);

CREATE TABLE chinese_follows_given_count
SELECT a.follower_id, COUNT(*) AS follows
FROM chinese_follows_given a
GROUP BY a.follower_id;
CREATE INDEX follower_id ON chinese_follows_given_count(follower_id);

CREATE TABLE unitedstates_follows_given
SELECT a.* 
FROM followers a, unitedstates_users b
WHERE a.follower_id = b.id;
CREATE INDEX follower_id ON unitedstates_follows_given(follower_id);
CREATE INDEX user_id ON unitedstates_follows_given(user_id);

CREATE TABLE unitedstates_follows_given_count
SELECT a.follower_id, COUNT(*) AS follows
FROM unitedstates_follows_given a
GROUP BY a.follower_id;
CREATE INDEX follower_id ON unitedstates_follows_given_count(follower_id);

CREATE TABLE indian_follows_given
SELECT a.* 
FROM followers a, indian_users b
WHERE a.follower_id = b.id;
CREATE INDEX follower_id ON indian_follows_given(follower_id);
CREATE INDEX user_id ON indian_follows_given(user_id);

CREATE TABLE indian_follows_given_count
SELECT a.follower_id, COUNT(*) AS follows
FROM indian_follows_given a
GROUP BY a.follower_id;
CREATE INDEX follower_id ON indian_follows_given_count(follower_id);
