Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C33162A1DD
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Nov 2022 20:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiKOT3J (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Nov 2022 14:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiKOT3I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Nov 2022 14:29:08 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDBD22511
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 11:29:07 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id f201so17148261yba.12
        for <linux-xfs@vger.kernel.org>; Tue, 15 Nov 2022 11:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+lQpyWwSWzN8lsupAP005HALxU0EgMSxVwo2KXOm2F8=;
        b=hQalyjd5kXW0ha9wqfRx/rNB500Qel/jZ5LZLa7aS/qpgFVT1bqY9EsduYIs8BxUYx
         4CP88T7TF7gu9i8z1yfVbNE8f22y9+YjjvilToY2FEFTfDay6wavmEPVfXKzxr/QQ2/V
         71xi/XkEkZpYzLi+7QxN483uCVXM/DBWgGi4Z7Nsv5E2KC6qb6CdMHUZ2vhBiVKKCOdc
         y2bAhoH3L+5XZLahTGMHZSPNrxhiXv9Qbta9uBSXF1flj9LptftNALHnDFlfcan8WUpa
         ym29YpBd7QefgTVjT31u9Gvjrq13AYIEIDdU481enTbemnGZz9MaZ/FOxCgdpTnYDTD4
         gzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+lQpyWwSWzN8lsupAP005HALxU0EgMSxVwo2KXOm2F8=;
        b=bO36hFJvbOZpA1gObGIcM8QC2WTcwLkAt4eC7aJbGOngtuJ5x6aVtpllSYSLUpmp/3
         yOhhEd1emKKfnTdkRO6qz2bz8kHUgi3LyCktx6HhdLSRjtFw70UlfRFv3AZF7LrAmhvv
         NMOa6UIFGC/qeaEpZoHuo3TnihiPkns2COexJ8oQbV7RQqocgJe8hymwsGpCSrdKxyxo
         0dhYNWyRg9Hbw2WjO2FVw/bbaGrMJan9y01o/dDBh4/kga9Go7QxtchgGEsxVDKbE/1J
         y2xTRY6SpBsCJFOr709YBXYejq5nRu12pFQmIUR43arGreg+v/ELstLqZwoIOwcEUj95
         g7Pg==
X-Gm-Message-State: ANoB5pleAYfGzcErF7V1wtRwjNKz4g4f/Eks87r0OdFhI8CoMpDCgMAJ
        Ag8SHux8aZnlGZdizKPL3nohu6ibFRvDCTfChfU=
X-Google-Smtp-Source: AA0mqf5ivdidplQZ42cJNWcTCIcYkw7Ju1aDdNCJqPMgW+/atxW1on0zIPAtkRlvgW57JhDrqqMNIAJrbz57qMjK5V4=
X-Received: by 2002:a25:d254:0:b0:6cf:e761:41ed with SMTP id
 j81-20020a25d254000000b006cfe76141edmr18287686ybg.82.1668540546391; Tue, 15
 Nov 2022 11:29:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:a515:b0:313:4849:5ee8 with HTTP; Tue, 15 Nov 2022
 11:29:05 -0800 (PST)
Reply-To: mariageorgy5@gmail.com
From:   "Ms. Maria" <elisabethede443@gmail.com>
Date:   Tue, 15 Nov 2022 20:29:05 +0100
Message-ID: <CA+5__5UmCR+7yhkVxwwTgWThj_ojFuBLnPE3Q9K2Y04x5fiVtg@mail.gmail.com>
Subject: Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2e listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5223]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [elisabethede443[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mariageorgy5[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [elisabethede443[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear,

Please don't find this mail offensive.  I was caught with hard drug
cocaine 8 years ago and since then I was sentenced to life
imprisonment. I have sincerely repented in prison through the help of
many pastors visiting us every weekend.

I am now a totally new person in God and have decided to give out my
whole fund to charity. I am looking for an honest and godfearing
person to help me share or invest this fund for the poor ones in an 8
poorest countries around the globe.

Contact me back if you have interest and can do it perfectly.

Best Regards!

Maria D Russian national
