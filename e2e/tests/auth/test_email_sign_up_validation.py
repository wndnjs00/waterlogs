"""TC-AUTH-03: 이메일 회원가입 입력 유효성 검증."""

from pages.sign_up_page import SignUpPage, _has_accessibility_id

_VALID_PASSWORD = "ValidPass1!"


def test_sign_up_invalid_email_shows_error(driver):
    """A. 잘못된 이메일 형식 → 안내 문구."""
    page = SignUpPage(driver)
    page.open_sign_up_form()
    page.enter_email("not-an-email")

    page.wait_for_message("이메일 주소형식에 맞게 입력해주세요")
    assert _has_accessibility_id(driver, "이메일 주소형식에 맞게 입력해주세요")
    assert not page.is_sign_up_submit_enabled()


def test_sign_up_weak_password_shows_error(driver):
    """B. 규칙 미충족 비밀번호 → 안내 문구."""
    page = SignUpPage(driver)
    page.open_sign_up_form()
    page.enter_email("valid_user@test.com")
    page.enter_password("short")  # 영문/숫자/특수문자·8자 미충족

    page.wait_for_message(
        "비밀번호는 8자 이상이며, 영문/숫자/특수문자를 모두 포함해야 합니다"
    )
    assert not page.is_sign_up_submit_enabled()


def test_sign_up_password_mismatch_shows_error(driver):
    """C. 비밀번호 ≠ 비밀번호 확인 → 안내 문구."""
    page = SignUpPage(driver)
    page.open_sign_up_form()
    page.enter_email("valid_user@test.com")
    page.enter_password(_VALID_PASSWORD)
    page.enter_confirm_password("OtherPass1!")

    page.wait_for_message("비밀번호가 일치하지 않습니다")
    assert not page.is_sign_up_submit_enabled()


def test_sign_up_without_terms_keeps_submit_disabled(driver):
    """D. 약관 미체크 → 가입하기 비활성."""
    page = SignUpPage(driver)
    page.open_sign_up_form()
    page.enter_email("valid_user@test.com")
    page.enter_password(_VALID_PASSWORD)
    page.enter_confirm_password(_VALID_PASSWORD)
    # 약관 체크하지 않음

    assert not page.is_sign_up_submit_enabled()
