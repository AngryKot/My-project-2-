using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement; // Для загрузки уровней
using DG.Tweening;

public class GameMenu : MonoBehaviour
{
    public static GameMenu instance;
    public PlayerState playerState;
    public bool settingsExpand;

    public RectTransform[] settingsButtons;

    public Image vibrateImage;
    public Sprite vibrateOnIcon;
    public Sprite vibrateOffIcon;

    public Image soundImage;
    public Sprite soundOnIcon;
    public Sprite soundOffIcon;

    public Image musicImage;
    public Sprite musicOnIcon;
    public Sprite musicOffIcon;

    public GameObject levelSelectionPanel; // Панель выбора уровней
    public Button[] levelButtons; // Кнопки для выбора уровней (например, 3 кнопки для уровней 1, 2, 3)

    private void Awake()
    {
        instance = this;
    }

    private void Start()
    {
        foreach (var button in settingsButtons)
        {
            button.anchoredPosition = new Vector2(184f, button.anchoredPosition.y);
        }

        // Устанавливаем действия для кнопок выбора уровня
        for (int i = 0; i < levelButtons.Length; i++)
        {
            int levelIndex = i; // Локальная копия индекса, чтобы избежать замыканий
            levelButtons[i].onClick.AddListener(() => FinishMenu.instance.GoToLevel(levelIndex));
        }
    }

    public void SwitchSettings()
    {
        settingsExpand = !settingsExpand;
        foreach (var button in settingsButtons)
        {
            DOTween.To(() => button.anchoredPosition, x => button.anchoredPosition = x, settingsExpand ? new Vector2(-184f, button.anchoredPosition.y) : new Vector2(184f, button.anchoredPosition.y), 0.3f);
        }

        UpdateVibrate();
        UpdateSound();
    }

    public void ToggleLevelSelection()
    {
        // Показать или скрыть панель выбора уровня
        levelSelectionPanel.SetActive(!levelSelectionPanel.activeSelf);
    }

    public void SwitchVibration()
    {
        playerState.vibrate = !playerState.vibrate;
        playerState.Save();
        UpdateVibrate();
    }

    public void SwitchSound()
    {
        var v = PlayerPrefs.GetInt("Sound", 1);
        v = (v + 1) % 2;
        PlayerPrefs.SetInt("Sound", v);

        playerState.ChangeSound(v == 1);

        UpdateSound();
    }

    public void SwitchMusic()
    {
        var v = PlayerPrefs.GetInt("Music", 1);
        v = (v + 1) % 2;
        PlayerPrefs.SetInt("Music", v);

        playerState.ChangeMusic(v == 1);
    }

    void UpdateVibrate()
    {
        vibrateImage.sprite = playerState.vibrate ? vibrateOnIcon : vibrateOffIcon;
    }

    void UpdateSound()
    {
        soundImage.sprite = PlayerPrefs.GetInt("Sound", 1) == 1 ? soundOnIcon : soundOffIcon;
    }

    void UpdateMusic()
    {
        musicImage.sprite = PlayerPrefs.GetInt("Music", 1) == 1 ? musicOnIcon : musicOffIcon;
    }

    void LoadLevel(int levelIndex)
    {
        Debug.Log($"Loading Level {levelIndex + 1}...");
        // Замените "Level" на имя ваших сцен
        SceneManager.LoadScene("Level" + (levelIndex + 1));
    }
}
