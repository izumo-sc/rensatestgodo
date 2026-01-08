using Godot;
using System.Threading.Tasks;

public partial class ClickMoveToCenter : Node2D
{
	/// <summary>
	/// 画面中央へ移動するまでの待機時間（秒）
	/// </summary>
	[Export]
	public float DelaySeconds = 1.0f;

	private bool _isProcessing = false;

	public override void _InputEvent(
		Viewport viewport,
		InputEvent @event,
		int shapeIdx
	)
	{
		// クリック検出（左クリック）
		if (@event is InputEventMouseButton mouseButton &&
			mouseButton.Pressed &&
			mouseButton.ButtonIndex == MouseButton.Left &&
			!_isProcessing)
		{
			_ = HandleClickAsync();
		}
	}

	/// <summary>
	/// クリック後の一連の処理
	/// </summary>
	private async Task HandleClickAsync()
	{
		_isProcessing = true;

		// ① 消える
		Visible = false;

		// ② 1秒待機
		await ToSignal(
			GetTree().CreateTimer(DelaySeconds),
			SceneTreeTimer.SignalName.Timeout
		);

		// ③ 画面中央を取得
		Vector2 screenCenter = GetViewportRect().Size / 2;

		// ④ 中央へ移動
		GlobalPosition = screenCenter;

		// ⑤ 再表示
		Visible = true;

		_isProcessing = false;
	}
}
