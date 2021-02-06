Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EE7311E21
	for <lists+linux-xfs@lfdr.de>; Sat,  6 Feb 2021 15:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhBFO4q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 6 Feb 2021 09:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhBFO4n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Feb 2021 09:56:43 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2B3C061224
        for <linux-xfs@vger.kernel.org>; Sat,  6 Feb 2021 06:56:03 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id df22so12957205edb.1
        for <linux-xfs@vger.kernel.org>; Sat, 06 Feb 2021 06:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=sY4fgq/DSyThalwU7QX+pWYKs/8sGH7ZznMUn5qQ1EY=;
        b=LKTydslwkBHjRBD/0U/iTEH4rnbV3bQM+PEGCYVnKRWqCpBuxiyyJWlH+XxoDVh2b/
         HFZWTfmHMpqHsMdZMtB/2gIQb6SrU7HNNg4Pbg6aDUnwTTYa4ErmhrI4rReQ/aAXsVVq
         wwdcwN/6PaD+QIBMSCrJ3tjlNWUWWctCNR4ZtJFT9jJA61Cvt48scMGk7sXyE5r6ccDR
         P3Y4T1+1qudMtHcSBxbPHr6TwKJ2cZ6qwDAUiEhK7eJUvy9B8fetIBZUma+T+Fz/B+MD
         X/a9+Uu3zKZgMCYnPeP2cVIikCY3zOffZKfAVZgicLkOAYPws+uBFNEJqRYUVgffaWvv
         FXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=sY4fgq/DSyThalwU7QX+pWYKs/8sGH7ZznMUn5qQ1EY=;
        b=nEQempFfEVrqTi9ZhXi5pp9Ac6dfhnPNgYEUctFKOVwjhW+2B86ZvjxA2/ZLVtYj6v
         7j1AG4DkHLZ6pzAsuo58JraBMHrMHMczI+Ghq99Rt5K1AxUBY10V811xUHH00FObs1Jg
         vh63ShElzcBRNQNKxH0dM8oP+P21gH19k4zCxvRcn/emwme8Fi3ldP8ZBQUbenmr57cQ
         NGe2cnElEWFzNXJ+/SFqVbXHeDXN5ZlNH+XxMvfc0AwOCEjzX7zDDfjVsFq30PVBLzyi
         DUSjGIfPY8xJkklFJjLGHkxmR1M0DVj6ykWBb9T9S93/CqnvtsRqS8WPrVIokrUnZX2B
         YikQ==
X-Gm-Message-State: AOAM5334wjBIDO6/EMd5a1AGSpdZcomMfHMM6ZwNgxD0DwlY/0qFeMse
        Uki5PLdLeCdcVeaqCbe64VdPCJz+5M5HqVlThq0=
X-Google-Smtp-Source: ABdhPJzHuK3LvHqbpz7y7FkmfdCO+mLpCyAcQI6UI8feOQjxzQakBQkfzu17R8y2ODfxQ2tLrHWIUKNuNGqsXo7YnO0=
X-Received: by 2002:a05:6402:3508:: with SMTP id b8mr8823036edd.341.1612623362722;
 Sat, 06 Feb 2021 06:56:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:25d0:0:0:0:0 with HTTP; Sat, 6 Feb 2021 06:56:02
 -0800 (PST)
Reply-To: lawyer.nba@gmail.com
From:   Barrister Daven Bango <stephennbada9@gmail.com>
Date:   Sat, 6 Feb 2021 15:56:02 +0100
Message-ID: <CAGSHw-BTtjFX0_eZQxh6ESq0ccY53ZvhP0ukJTUOzzjPJEQARQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--=20
Korisnik fonda =C4=8Destitanja, Va=C5=A1a sredstva za naknadu od 850.000,00
ameri=C4=8Dkih dolara odobrila je Me=C4=91unarodna monetarna organizacija (=
MMF)
u suradnji s (FBI) nakon mnogo istraga. =C4=8Cekamo da se obratimo za
dodatne informacije

Advokat: Daven Bango
Telefon: +22891667276
(URED MMF-a LOME TOGO)
