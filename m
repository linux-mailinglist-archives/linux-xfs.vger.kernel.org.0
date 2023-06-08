Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5641A7279AC
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Jun 2023 10:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233806AbjFHILa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 8 Jun 2023 04:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbjFHIL3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jun 2023 04:11:29 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108C6198B
        for <linux-xfs@vger.kernel.org>; Thu,  8 Jun 2023 01:11:26 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-3f9c60bc99cso2319031cf.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jun 2023 01:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686211885; x=1688803885;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=a4X09bmWM22XKEiz3YUEZzaKjcmPm5GWneDoQr3T5heWXLIR6pzRuhrKFD8KaaKyYd
         VWRL8Vd7TeLIxGUXQN+BOeZXwFqJKtcE+1mnVQtLtYGe4yyQvBIhLqCuMk89ShRZGn6V
         cq3Jy0BioTQmqmxoQzeA2uVkRqaiz8v2TmCRke2MoZQxCvFeix2J1vIqzWqB2mHmM2BV
         SJ9gXB7POuXahb75zIkzdP/pIgm/lSNlA4l4T5q33Hp6b9oDzm+zS+mDamZJ0mftp10D
         fdiv1PO03uWwQ/73nY1nNw0LnaW8IdCyDla+1G4gJyXxc5EsrIMba31FXzMQ362yA6EJ
         n1Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686211885; x=1688803885;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=lUSleLW6TZrHD8sZ0YM6Yd4BdqtuztPYCAXio77N0/81wMzLA5zMfsxofvPALY3Ynr
         g1X9Sw6wgPrVo9elZ28RbzbsZS9liO4ck3FOhm9MldCK+d3fAE6o22moqBWhwBUh3Pp3
         Y2iFxbu03D4swxRYjZ3liyIOqL7Ewq59kwrEOaCvz/jt8QfZLth3OubOtUtXHxdqdEt9
         LlsIV8KeYe1OSrS5ReTjMIRUSWz5j2DVJa046VYhMPDWC0tvxWH0PxdVk761WOelw6yV
         ANgF3NiahJ/N8RrS5Cqgs6QXk+yA/Ri1GQ46n0ycku5zdhuWYIQjIY6ZVF2LBpRYZiu9
         AZPQ==
X-Gm-Message-State: AC+VfDz6bkFy/VFLXlb6FtLYVIAUUBgC7bU/S0nQQWTa5OcDY4ZjEtry
        3xj1OqmWH1qVMZRMb1OICD8zo+PKWWpgA0p4fDfyjiEN6ow=
X-Google-Smtp-Source: ACHHUZ4rCcPhZez7FdW9bm5vjy7SxTISbHG8qhvk7oRBdso3vUqhu5Sqq4ePewNQOiuiTg4zPKgv4oQz05FLWSucVQg=
X-Received: by 2002:a05:622a:100b:b0:3f9:a771:eb55 with SMTP id
 d11-20020a05622a100b00b003f9a771eb55mr6857781qte.52.1686211884902; Thu, 08
 Jun 2023 01:11:24 -0700 (PDT)
MIME-Version: 1.0
Reply-To: chenlei0x@gmail.com
From:   chenlei0x <losemyheaven@gmail.com>
Date:   Thu, 8 Jun 2023 16:11:12 +0800
Message-ID: <CAKEZqKKdQ9EhRobSmq0sV76arfpk6m5XqA-=XQP_M3VRG=M-eg@mail.gmail.com>
Subject: 
To:     linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

unsubscribe
