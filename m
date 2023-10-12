Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C5D7C74D3
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Oct 2023 19:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347347AbjJLRdp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Oct 2023 13:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344198AbjJLRdo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 13:33:44 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE7618B
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 10:33:41 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id 4fb4d7f45d1cf-533d31a8523so2200118a12.1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 10:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddatasolution-com.20230601.gappssmtp.com; s=20230601; t=1697132020; x=1697736820; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ogr/5eM7qfn+zrypn6phy/AwkbVCedzchxlSjrzZePI=;
        b=dPisb7E62/BABIJcDUsfxtI6TQWmXI5TNcBzT/lIEAFJ+LBH2UlptIfk+SG2qX2BLd
         EjyRModH/BumvVKTqGToryF18GpnuK0giAEiGb9g5DCzfTHQoB21os9kks87bNtBC2rl
         yTNZtBJLtZAhdXERGfoyI2UTmNipTGtdLDj4F77VJj8oNEg/OHQy+X90O/kOKoh56+vn
         5xGS7W8WU3NLSuxKFssuiz5+kHD00uHC3RnTmaTZIvlAvAeyD7tVjwEI66igtoJ7hDAu
         1t+VOSkoRbWQK2iA7tvymCryqSwCbAElQoqrnnMkZkpF9A5Hd3bT221ng17HlrKzcYJc
         9x5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697132020; x=1697736820;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ogr/5eM7qfn+zrypn6phy/AwkbVCedzchxlSjrzZePI=;
        b=H1++7Jhq9DupTtZsbu/JujjBAlR34WbTFIk2Ga1CQS5KZaicP7d4XjmYZBHlU3/3CH
         0Y6frgVqyd26n2TXRc+X/6BM6grFHlSjO8DwSNF1C0W4IcU2iZkLnh7b0UzoSRzPYz8+
         uZbGkG0vTGBo/m/TYHEuQtKm8waCDnyp6W0IVywTj5WKVfPEYO4ozCx9fV59oUFfB+eP
         jDEoEU+YtxsGsPV8WByBY7SJAsHpmeDK2M/422042ixXceZG/lmcldjy4HjiWMaCAc/d
         qvwqkBmOOVdFmH0EGZki9g5KdxMv7cAmeLzy6lQiKrw5nEqjqlM7JKf/WnLiSX357mn3
         i4UA==
X-Gm-Message-State: AOJu0YzB5uCcyLt+pTszEZL+tRPISiZBqnz+/L8U7/dLtTwHjKwCBDg3
        Y/tiXT+VVHGEv54fcGY37W/Rlssju7zG/jZXXy1z0w==
X-Google-Smtp-Source: AGHT+IGOuQUla7LaNnj9O7gQyZDv512jLD9tm3a0tRDFFOzzCnzxmlyJuShSGJW/42MfmjVmtD/NsuE01WBpYzl2urI=
X-Received: by 2002:a05:6402:60e:b0:523:33eb:1103 with SMTP id
 n14-20020a056402060e00b0052333eb1103mr22554957edv.14.1697132020381; Thu, 12
 Oct 2023 10:33:40 -0700 (PDT)
MIME-Version: 1.0
From:   Anna Maria <anna@gooddatasolution.com>
Date:   Thu, 12 Oct 2023 12:33:28 -0500
Message-ID: <CAMfJWr52d_YtimuSa3+A3S-+mq9eNbimneyWg=gAC4wHix4hEg@mail.gmail.com>
Subject: RE: MJBizCon Attendees Email List- 2023
To:     Anna Maria <anna@gooddatasolution.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I hope you and your family are safe!

Would you be interested in acquiring MJBizCon Conference Attendees
Data List-2023?

Each Contact Includes: - Org Name, First Name. Contact Job Title,
Verified Email Address, Website URL, Mailing Address, Phone Number,
Fax Number, Industry and many more=E2=80=A6

Number of Contacts: - 10,653
Cost: - $1,479

Appreciate your time and I look forward to hearing from you.

Kind Regards,
Anna

Marketing Coordinator
