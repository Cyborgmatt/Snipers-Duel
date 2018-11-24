var quests = {};

function InitQuest(name, description, target)
{
	var panel = $.CreatePanel("Panel", $('#Quests'), '');
	panel.BLoadLayoutSnippet("Quest");
	
	panel.FindChildTraverse('QuestTitle').text = name;
	panel.FindChildTraverse('QuestDescription').text = description;
	panel.name = name;
	panel.desc = description;
	
	SetQuestProgress(panel,0,target);
	return panel;
}


function SetQuestProgress(quest, current, goal)
{
	if(goal > 1)
	{
		quest.FindChildTraverse('QuestProgress').text = current + "/" + goal;
	}else{
		quest.FindChildTraverse('QuestProgress').text = "";	
	}
	
	var percent = (current / goal);
	var background = quest.FindChildTraverse("Background");
	background.style.width = (percent * 100) + "%";
	
	quest.goal = goal;
	quest.current = current;
}

function RemoveQuest(quest)
{
	quest.DeleteAsync(0);
}

/* Event Listeners */
function OnNewQuest(dat)
{
	var quest = InitQuest(dat.name,dat.desc,dat.max);
	quest.tag = dat.id;
	quests[dat.id] = quest;
}

function OnQuestUpdateProgress(dat)
{
	for(var x in quests)
	{
		quest = quests[x];
		if(quest.tag == dat.id)
		{
			SetQuestProgress(quest, dat.current, dat.max);
			break;
		}
	}
}

function OnQuestRemove(dat)
{
	for(var x in quests)
	{
		quest = quests[x];
		if(quest.tag == dat.id)
		{
			RemoveQuest(quest);
		}
	}		
}

function debug()
{
	GameEvents.Subscribe("quests_create_quest", OnNewQuest);
	GameEvents.Subscribe("quests_update_quest", OnQuestUpdateProgress);
	GameEvents.Subscribe("quests_remove_quest", OnQuestRemove);
}

debug();