import app

def test_main(capsys):
    app.main()
    captured = capsys.readouterr()
    assert "Hello, DevOps World!" in captured.out