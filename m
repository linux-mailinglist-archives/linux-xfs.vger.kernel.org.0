Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A825477AD
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jun 2022 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiFKVUP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 11 Jun 2022 17:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiFKVUN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Jun 2022 17:20:13 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3151B5638E
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 14:20:13 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id w16so3531036oie.5
        for <linux-xfs@vger.kernel.org>; Sat, 11 Jun 2022 14:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=+ItlcMKqqkBBLUmB28twwA+U+G4Zq/zqbGLcRIo9tDc=;
        b=MkxKz+6zjFZD12495n6iFQ2sDIGLM540gceysbIo/nS048jvA1+Y9evJN6fBqgPmUY
         riYEUGmS36t1ll3fRZwOCzJsl/1SovAHic/NjieEdaFdSHQkuwYpvSVPda6OD83W/G3m
         3znlgGbyfJnM3/9rAsqiBaVMtgNsDENVsuhLqrCkee3y0ImFbYItuLtc+6RaeJIIQOXG
         mU298Upnf/TCKSIdjE30Oqh1YC6qiodsIT3DJwa26Me18XxXy1x131P+tgA9iFpAJ0LQ
         u5EnXgGbkgddzqU5WfEYbcCNqPvgO2gVIkSr27t76FBoTEad2kBQVZzIW7m7EjzPMAV6
         ZvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=+ItlcMKqqkBBLUmB28twwA+U+G4Zq/zqbGLcRIo9tDc=;
        b=XVikLGph0EJ12qJCv3qKmGiXv870HDUG0RF+4f671zzjc6DXb2Yp0Q6EnBRIbmsBHB
         jIjx2TaRNuGUfUwrzx4UcSAPv1fygkcMXAkhQGEbB36wpIbWV89HLIE/T/U+0+NY8ASL
         efv3RLpzl+2voFk4oyi/tifMUaXMZwf4YtyMNOwUV5QKQgc6Qvcy3UWSEMxetOFZK4Wr
         i9YWPmlicTMABB8zYxcTqkARXHx6/UtQZI4+pSt7gy1X9ANtiURtmf6yTT5LFpmQj56W
         lv7qNQnEEEBVk4zoHW1HNxRR+Jy6MVppQaKVqaEs2Qb4A8fmT7sv+HtenEYJmiGaAXRf
         CNWw==
X-Gm-Message-State: AOAM532pn/861+Zd0pIvv+5mMkH9n/MOY8OikksnNUtoWi0MV5TaYUlW
        pmyW6gXvfLLTZ9ZLUtL8ZFgwV1Y1ifbjqJFj1GE=
X-Google-Smtp-Source: ABdhPJy2x5T4H+QE2Y3x1lOzU8KF16kS695T723/LkXu8yLKJhJKw5CncPSwD6CGt80/7h9Bj+kZPJKPz1K9r197ALs=
X-Received: by 2002:a05:6808:23d5:b0:32e:c7f0:800e with SMTP id
 bq21-20020a05680823d500b0032ec7f0800emr3351439oib.91.1654982412550; Sat, 11
 Jun 2022 14:20:12 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6839:1c01:0:0:0:0 with HTTP; Sat, 11 Jun 2022 14:20:12
 -0700 (PDT)
Reply-To: mrsrebeccapaul09@gmail.com
From:   mrs rebecca paul <paulchukwu5447@gmail.com>
Date:   Sat, 11 Jun 2022 23:20:12 +0200
Message-ID: <CABTDUZ90NJxcVHPKxSmzKxGBe1Ce3qzP2DZ28VwPVS47T75QbA@mail.gmail.com>
Subject: =?UTF-8?Q?ACEPTA_ESTA_DONACI=C3=93N_CON_TEMOR_DE_DIOS?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:242 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [paulchukwu5447[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [paulchukwu5447[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrsrebeccapaul09[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  2.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.0 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  0.6 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Mis saludos.

Soy la Sra. Rebecca Paul, viuda del difunto Dr. Paul. te estoy contactando
porque me estoy muriendo. Recientemente, mi m=C3=A9dico me dijo que tengo a=
lgunos
meses de vida debido a la cirug=C3=ADa que se realiz=C3=B3.

Aunque lo que me perturba es mi situaci=C3=B3n actual debido al da=C3=B1o d=
e
mis m=C3=A9dulas espinales en el accidente. Habiendo conocido mi condici=C3=
=B3n, he
decidi=C3=B3 Will/Donar la suma de ($ 2,500,000.00) a la caridad y
individuo para la buena obra de Dios, y para ayudar a los hu=C3=A9rfanos, m=
enos
privilegiados y tambi=C3=A9n para el auxilio de las viudas, porque yo soy e=
l
=C3=BAnica persona sobreviviente y nadie m=C3=A1s que heredar=C3=A1 este di=
nero ahora
que mis tres hijas est=C3=A1n muertas.

Todo lo que quiero que hagas es ayudar a mantener a salvo este fondo que es
depositado bajo la custodia de la empresa de seguridad antes de que llegue
confiscados o declarados inservibles.

Tambi=C3=A9n he decidido que usted tome el 40% del fondo de la
fondo tras la liberaci=C3=B3n exitosa de este fondo. te dar=C3=A9 m=C3=A1s
detalles tan pronto como reciba su respuesta

Permanece bendecido.
