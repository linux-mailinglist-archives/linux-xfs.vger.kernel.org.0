Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214BB76C4A3
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Aug 2023 07:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbjHBFMp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Aug 2023 01:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjHBFMo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 01:12:44 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E077C10B
        for <linux-xfs@vger.kernel.org>; Tue,  1 Aug 2023 22:12:42 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-99c10ba30afso108997066b.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Aug 2023 22:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690953161; x=1691557961;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BpHjTifPZTHZJC0mhyywdWJpPNNsyiBvnryQcIT18iI=;
        b=mpXnpXdrJj7s+7UmpBc4B37s2Ix1alDMYsY4xkneZDXccdVx1qs3nm8ZTxpmnZ3hiO
         tr1BnTEUds07sUoeUePowXyHMUIL3Es/HATHC/JliuRlRWWNFMwBvUi4V9OMCAawJjzn
         W/K7BLIbnKLoxTRq/tHuZHqdSci2ra/iK2B3+XEdIMeMDvxAaMTzbAc28YesciV8uWOu
         NisANJTKHzVu6kUlW5rs3YTUvlQLlrCnO4dmPwMgSDr3mYqx9XpKaAqUX1VsmLrUjz1G
         YnN29OmC501CxPymQ3KVYrWOvPz3UN8pcKJmjavU0LaywOfLU4fKCjyNXDWY6bGMafm8
         dgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690953161; x=1691557961;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BpHjTifPZTHZJC0mhyywdWJpPNNsyiBvnryQcIT18iI=;
        b=Uz+k0KHTKFFcD0T7mwIQjdzqwAWPE99MAuNSYJjwlERL11bRpW6zAYJTTnbcSuunnI
         oL4IYpS+xvt8Edho8cdcTStqbAeHTIm0AIqFjc7YSa/RleCeYFYPyIdf7eDNFptgOOi9
         uXPXEaTqU8fniwQ8QEZhDjFaEZORyD4yMCFu8eO5loqsOB1rMwtkIQcfTNTRds8jl/ox
         oAvvS0QIrYKDAY+PGxQ7gx/In3+qSe6EdEMIqxkuadAIBkOCg+7kTtIRiih9eRj3DC2F
         AW/BzBeJD54OovdD0Vgxni/bQ1iv3Qe7w+mAaMcGJ5LG4su1tf2jrqR6pfb3XutGFlj4
         uMfQ==
X-Gm-Message-State: ABy/qLZDuGMkGh7MdLkb9Ln7nzu4lqexBjgr7iCtdWKjq0iaE9YSLSRI
        H6Mpf9RyAEY2tZ69myNJOmodiyiUlTYJosVK4Lo=
X-Google-Smtp-Source: APBJJlF9wC5J/GcJxyZ5tGHONAJ5Bcfgmh1/+Vde6L1WMl0Y9lUD7sIXoJfIlkCyNn5mNuK0Tz+ikCTbXZ0tgubaMSI=
X-Received: by 2002:a05:6402:27c8:b0:51f:ef58:da87 with SMTP id
 c8-20020a05640227c800b0051fef58da87mr6599584ede.2.1690953150408; Tue, 01 Aug
 2023 22:12:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7208:5595:b0:70:8cb9:9fa8 with HTTP; Tue, 1 Aug 2023
 22:12:29 -0700 (PDT)
From:   Mr Chris Morgan <chrismorganuba@gmail.com>
Date:   Wed, 2 Aug 2023 06:12:29 +0100
Message-ID: <CAAP_aETZNca65Je95XJiFXVDvZRKhv-dq6a7__XbX9X1aZpYHQ@mail.gmail.com>
Subject: Urgent.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.1 required=5.0 tests=ADVANCE_FEE_5_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,LOTS_OF_MONEY,MILLION_USD,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.0 RCVD_IN_DNSWL_BLOCKED RBL: ADMINISTRATOR NOTICE: The query to
        *      DNSWL was blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [2a00:1450:4864:20:0:0:0:636 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [chrismorganuba[at]gmail.com]
        *  0.6 MILLION_USD BODY: Talks about millions of dollars
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  3.0 ADVANCE_FEE_5_NEW_MONEY Advance Fee fraud and lots of money
        *  2.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

-- 
Attention: Sir/Madam,

Compliments of the season.

I am Mr Chris Morgan, a senior staff of the Computer Department of
Central bank of Nigeria.

I decided to contact you because of the prevailing security report
reaching my office and the intense nature of polity in Nigeria.

This is to inform you about the recent plan of the federal government
of Nigeria to send your fund to you via diplomatic immunity CASH
DELIVERY SYSTEM valued at $10.6 Million United states dollars only.

Contact me for further details.

Regards,
Mr Chris Morgan.
