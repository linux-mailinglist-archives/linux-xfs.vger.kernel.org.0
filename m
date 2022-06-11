Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363B65472EA
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jun 2022 10:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiFKI3o (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 11 Jun 2022 04:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiFKI3n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 04:29:43 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2985511829
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 01:29:42 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id h23so2005624ejj.12
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 01:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dk8zUgPEAH8sJMme+gRlsmI7BdAAwGXVFJaTHtWa1SI=;
        b=C1ImQNBLXJNsimA9xPCxJPABiumru9607KyWTR13sYWZgB5QebqjqcJbDcIo2i3Tgt
         fR2Hj+RY8/PBnrAj9yIrfVlKCaqPY4CffDOLC6N2NHm09COw2xGaJTPTJ7sSlXusr/Xa
         5i/rJgk4PdrUnIeuJZOlGpXfJy1ow4cp6oIEM5WqBDjdnCZs1OkN+3S5zj1WPVN5mcoF
         Nqqr3Mv+aZCdrsI89eNOZReccHb2qgg4pxUwYpoRXWU3KTBHKzsahN+Zep0FS06jpOJD
         lpVxmsJ+QdsHqZzYarIsO3uWh3aDXvueHFIA4TjgtsQ90y6txPYumPuBReKEEj+QgwIf
         W8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=dk8zUgPEAH8sJMme+gRlsmI7BdAAwGXVFJaTHtWa1SI=;
        b=pRxnUIvxTnzfBj95S1Mne0PX33lgJXnAglSrNCd+zeqt7eLLVCPR0fPMuENAOX/1fA
         NcQEqnDh3xlevr8oGpvaFYmAeEb0n306X9NfG0QOJGtPwb+LVRxlSbGGaUEjK0irVre4
         1anPFjFOrib68nj/W8ks3Tl4yDSuUe9da/BdJEIkiZ+6MIFjNMvDx8PN/wG8v/NxiRww
         JWvPAPd/LLpOuBg1aSdRpUddvlSSN2RMAW2tGN2CuBAe9JLHeMHQXiXe8xBjY979kHvn
         1FIBlqeGbxYAZ4CxyaJdxUTuxI+cXLghTy1JA/hyreEUvwDK9AWlwft+Sw5/vZyTrIHo
         Jzkw==
X-Gm-Message-State: AOAM53313tD3YKh8hFWT6iN3ckEkCdePMquPw5gpkgUE/ww3ZYRp236z
        17s7Pk9LcsKBtBmfQV0ccCheC/R309vPv59ccu4=
X-Google-Smtp-Source: ABdhPJxflUa9MSVHSfGnb11ps9lm7rWRHggckm6QcN76PRdPl1NjAQRRVdfuWcmo1yZAlt6ozKqly6bLrg+2YtBbdHs=
X-Received: by 2002:a17:907:2d87:b0:711:dd41:1e72 with SMTP id
 gt7-20020a1709072d8700b00711dd411e72mr21140518ejc.742.1654936180686; Sat, 11
 Jun 2022 01:29:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6400:2409:0:0:0:0 with HTTP; Sat, 11 Jun 2022 01:29:40
 -0700 (PDT)
Reply-To: robertbaileys_spende@aol.com
From:   Robert Baileys <shamsuumar753@gmail.com>
Date:   Sat, 11 Jun 2022 10:29:40 +0200
Message-ID: <CAEH6w0Y+r2+r4-2d1X9KJ8buLmvRC+4qFZUG57ab0crh7K1okQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=6.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:630 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [shamsuumar753[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [shamsuumar753[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--=20
Hallo, lieber Beg=C3=BCnstigter,

Sie haben diese E-Mail von der Robert Bailey Foundation erhalten. Ich
bin ein pensionierter Regierungsangestellter aus Harlem und ein
Powerball-Lotterie-Jackpot-Gewinner von 343,8 Millionen Dollar. Ich
bin der gr=C3=B6=C3=9Fte Jackpot-Gewinner in der Geschichte der New York Lo=
ttery
in Amerika. Ich habe diesen Wettbewerb am 27. Oktober 2018 gewonnen
und m=C3=B6chte Ihnen mitteilen, dass Google in Kooperation mit Microsoft
Ihre "E-Mail-Adresse" f=C3=BCr meine Anfrage hat und diese 3.000.000,00
Millionen Euro kosten wird. Ich spende diese 3 Millionen Euro an Sie,
um auch Wohlt=C3=A4tigkeitsorganisationen und armen Menschen in Ihrer
Gemeinde zu helfen, damit wir die Welt zu einem besseren Ort f=C3=BCr alle
machen k=C3=B6nnen. Bitte besuchen Sie die folgende Website f=C3=BCr weiter=
e
Informationen, damit Sie diesen 3 Mio. EUR Ausgaben nicht skeptisch
gegen=C3=BCberstehen.
https://nypost.com/2018/11/14/meet-the-winner-of-the-biggest-lottery-jackpo=
t-in-new-york-history/Sie
Weitere Best=C3=A4tigungen kann ich auch auf meinem Youtube suchen:
https://www.youtube.com/watch?v=3DH5vT18Ysavc
Bitte antworten Sie mir per E-Mail (robertbaileys_spende@aol.com).
Sie m=C3=BCssen diese E-Mail sofort beantworten, damit die =C3=BCberweisend=
e
Bank mit dem Erhalt dieser Spende in H=C3=B6he von 3.000.000,00 Millionen
Euro beginnen kann.
Bitte kontaktieren Sie die untenstehende E-Mail-Adresse f=C3=BCr weitere
Informationen, damit Sie diese Spende von der =C3=BCberweisenden Bank
erhalten k=C3=B6nnen.

E-Mail: robertbaileys_spende@aol.com

Gr=C3=BC=C3=9Fe,
Robert Bailey
* * * * * * * * * * * * * * * *
Powerball-Jackpot-Gewinner
E-Mail: robertbaileys_spende@aol.com
