extends Control


@onready var title_label = $Panel/TitleLabel
@onready var name_label = $Panel/AchievementNameLabel
@onready var description_label = $Panel/DescriptionLabel


func _ready():

	visible = false

	AchievementManager.achievement_unlocked.connect(show_achievement)



func show_achievement(id):

	var achievement = AchievementManager.achievements[id]


	name_label.text = achievement["name"]
	description_label.text = achievement["description"]


	visible = true


	await get_tree().create_timer(3.0).timeout


	visible = false
