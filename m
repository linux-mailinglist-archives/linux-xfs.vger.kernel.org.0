Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530C45ECBF3
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Sep 2022 20:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbiI0SO1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Sep 2022 14:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiI0SO0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2022 14:14:26 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40441F3105
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 11:14:25 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id y2so839597ede.11
        for <linux-xfs@vger.kernel.org>; Tue, 27 Sep 2022 11:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=B+dZCp+luBR2/MhqDRxDxrim8Io2QXGcKHFks7FDQHA=;
        b=GGM4gRWiE0r+wVHs6l9VsBZnT/3h71jy4/kdQF90c7q7r/HEgT8H6WoQl8mISg1LMA
         odbw2HuyDqFEtMwXKwZXnFF6clfKKYgTxyA1YY7KRpSPp8sVp57pJ0OZeaE/gNuOIW5M
         fLootGORthJuu+nubOwr6s8eluIDmKkk6rESf5TC9UAOHpILOmbjfFgPq65Rc1eyR8Rq
         aUcg3FNzEpQdp7sDR2TcnCNZdYnZcrv2Pkp4k94UUxLKMyEm5JqbEDUEDdRzGInr/7CX
         8jUvQtGhm6WD2DjzNiiDdFwvAE9YQ8085uoorn99B5pEF+dC1gxFoyL2cWQK8ANGy2G2
         ExtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=B+dZCp+luBR2/MhqDRxDxrim8Io2QXGcKHFks7FDQHA=;
        b=gBdBW8VAzN4UrGT5DqEzC8H7U6thm8CVZdrfyiYIk1XmxXj/LECRQhDuMZPDc/Mb0a
         E7wjk91z8D1VuKPnIbAaB9tgMY7IycJfTAw23o+cS5QIaH0DTdUlWbs3pzjgIP0IesJE
         nwYM9vTUAeqcXKRt9iGUfAoJSyRZNWnPE5LQDf5iu8z2/LJfRoGLcBHOE5Ko1g+Pd3rO
         D2TINFMXsfPR9EljfmmNfKuTpOWg25PDBHSEGsBlGHGuLg8J4dTypCGojiCNw01bBXKt
         ZiEkQYwzGiSmm+BKnrCByv4m7ykq4ZcCmToLWZJ8gPsyUxxD+yOWvnpYfv/E/ua4MBB9
         eEnw==
X-Gm-Message-State: ACrzQf3J6hvoIxX0amJkM8wY+WSgnGEdGvSkjBap5jnRkiUYukYqPEMP
        fExl80zuPYDmG5R02oJTce0dRdb5XHOui2+TxPQ=
X-Google-Smtp-Source: AMsMyM4CbQRID1Yt+busI7lJ3+O2LvxViwt/imbbAay6S+3GMEQ/+V8lOkpEvQKjEBlkRogFXz9PW+CQ4kw20rEzz2Y=
X-Received: by 2002:a05:6402:298d:b0:451:5fc5:d423 with SMTP id
 eq13-20020a056402298d00b004515fc5d423mr28864835edb.102.1664302463667; Tue, 27
 Sep 2022 11:14:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6f02:850b:b0:25:108e:c581 with HTTP; Tue, 27 Sep 2022
 11:14:22 -0700 (PDT)
Reply-To: stefanopessia755@hotmail.com
From:   Stefano Pessina <solutiontechnology6021@gmail.com>
Date:   Tue, 27 Sep 2022 21:14:22 +0300
Message-ID: <CAKz2Y8f783De3tWqhaHLBNme-Wq=UzK09xY2QwCAf+_pkMw0VA@mail.gmail.com>
Subject: Geldspende
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:543 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5003]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stefanopessia755[at]hotmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [solutiontechnology6021[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [solutiontechnology6021[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

--=20
Die Summe von 1.500.000,00 =E2=82=AC wurde Ihnen von STEFANO PESSINA
gespendet. Bitte kontaktieren Sie uns f=C3=BCr weitere Informationen =C3=BC=
ber
stefanopessia755@hotmail.com
