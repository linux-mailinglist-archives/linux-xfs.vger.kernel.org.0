Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FFE18B05F
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Mar 2020 10:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCSJiI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Mar 2020 05:38:08 -0400
Received: from sonic306-19.consmr.mail.gq1.yahoo.com ([98.137.68.82]:35950
        "EHLO sonic306-19.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgCSJiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Mar 2020 05:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1584610686; bh=qmm0p7wyinKtAg7hjvo+utVQo287gRyoP2l2lOSevcE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=BhImPjtM3MKDATStMn+FS+9EOPBencFdCMmr6d1I3pbC3Jxr9NbMnjRUej1FUrCv1laqmECam8WdtQfLN+ghSbA58ReW5OnPL/Fohd5HSlN7t0l+yQ4/3Tkmmm7tSlw5+lv3XBmFXFaV+Gbzi2AHxKQoneZHVqoe7eHPVhi/kvYtRUqCx8fxlv+Qk7tsNWLC/wCvlf2Lbn6TmSBG+2wEiH6cUGz6/ygUA43OvdYJKmt9CGcSVrxqV+/y97xWktsIWHuDm1op6QdP3rMfBd98MDKHPP/+s3zGH8FRSDWnZaak9hTW5cHzOLJdIZnOhJsp8vTL+b1XhvNIC2axkr8mOw==
X-YMail-OSG: txmA8BQVM1nK6BrucW3XVSSyWY2xk5ug6imujj0S8jHmz6wt0bPoUTOuqCZpOms
 yech.tVjM8SWusP32qCBEgJuzcAk5AyO.QMzXu91S8ncjB6iq3zlCV0tuAbBkOBi4f4188LhN6V_
 twcJOsot4M_ri5wkqAFpUX6Up0m1TrcUIjFYBLkXteRV1t176kTv6kRygNijfklvqhvq5FL0VEWV
 w4haU9MrzgbaXSlNHzvWX_h3zQuU64M09PG9REjXNu4jkjdRtx1oyywZmWlcV6K0gWWIsDC8X7Xg
 tfxLNpVB3n3kCmPAga5pzrogcikjNl3rLle_xCmFHm_hPCHqJ7C4oD9Zjy9kSNQYwBdWZjsHP9fv
 5u5QrW5WdbpXutWJtS9h6m8LiIOiXq9PSYA7MIwswpjof_7tNMHqslHHPepCScf2d81ow5OZeg5W
 mjo1dT9MZxCiitTHXsrAfoDCUx.Cd8r25Zkd0boJhT2eO.3Ic01oGxNV.PGrf0DocLC0Ba2jo3lG
 LrJRqivLwWUnIrdckAj8lxD4YjVbu7k5WM8WdL2.S3J_JPoMg.38ZgLCJf6D.dS_Mn9r0h_el.im
 KOaHQbAX74zBLFzmpAuoYLhhJhJU1HI80d06CbIGG0rW5PWeq6VFf4rH7YpAZN.dTn_Q5PdT.wkK
 zo9nGyizndO0ncQY5Jt4ZVO6NDXGYOPzfm_UVHAtHVdJZpGVJG2zf_ywZgRRARFowFYe8uK3Brtb
 bOfHiZNxsCfOt7H3tuJQcwnJ34pzA4IQWfSHV5ESOQphgdUYd8ZaR78IGWv9o64e8fLYRJB_tCwK
 cC2_GZ7UbqTb6oSkMzJPsqO2f3k9wnEGzyrS.1aQYks3idwKPrxbpJt0LwRW6nlRgSMkA.EYShjA
 IRM_tJRuKG_OtXl7orGF_1B88UlhUqkGsYXS38UX2aN06d8fvZOyHY1R4Xio58k4Ou.2spbOnEPS
 sMq1r7y5IOZ2ceAh7h.oVNGmtDtx_LYwPJy3uxkz8m6SCDBhzh8_XKRCW9P9NBybj39KPztJvsT3
 zo0DLrFA8eQrdNkuMgampN8qBf5Lh.ihTH_2cW0TLv4kFAUsidw5EiMITWdW6eKnyjoapwxBNO7V
 3JPkKiQnaw02LhoSVygOW_MLsh7M5hmiRzZdkv9lAnn5hM_rG9_1Kec2FWDXNOtKG_GDWG21CcXF
 RKYI.tE6Jxvu3yBjp8IuC6aqQKobA1SKc4opS_IWvG5Zm_vAO3CN_3ZFfEHTMuzly_Sw_mFqHX.j
 KWqRrDWAVbWnAjATDjTChPJyifLZQO.yVsNXYgluUOeYVuLe.1JS5N9.wwfJ6etKXUQn9GiI-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.gq1.yahoo.com with HTTP; Thu, 19 Mar 2020 09:38:06 +0000
Date:   Thu, 19 Mar 2020 09:38:02 +0000 (UTC)
From:   Luana Usman Barbosia <assess.business@offcolormail.com>
Reply-To: luanabarbosia@yahoo.com
Message-ID: <1223774332.734727.1584610682033@mail.yahoo.com>
Subject: Donation For Charity Project,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1223774332.734727.1584610682033.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15471 YMailNodin Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dearest,
May the peace of God be with you and your family, I need your help to create a charity foundation for the benefit of mankind in the society to help the, widows, orphans and underprivileged in our word today, I'm investing the sum of USD$18.2M for Charity project, Kindly get to me through my private email address below [ luanabarbosia@yahoo.com ] as you indicate interest in carrying out this task with me. hope to hear from you soonest.
Yours faithful,
Mrs. Luana Barbosia.
