Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C3E2484B2
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 14:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHRMZ7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Aug 2020 08:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHRMZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 08:25:57 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688ADC061389
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 05:25:57 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p13so17400764ilh.4
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 05:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hXi9Ggj5DXa5CNhckkeGGVXOmxJktk4U2qFb5wWI8Mo=;
        b=fO0OP+TvT0pu+IU+KVcRIuu2z6scdm2qrLwsgtSey7b3KQvX/wPQP+v1B/w7/WgILu
         jnggWOnq9olqyrIXTZyYjAgh51JW0HOFASc4al3Kr0Qb4L6aQP147jCNSr2tUo6/KgQY
         gYA5LwENjytO1DmwxFx6A6yMJrx1ZTPKzxI4sg6f56d/NAx2vGOLxHILKF6B+J5hie/q
         Ob8dXAHtDwtkZj6qbem5rIWPY1N2vC+c/JKC7TtiG1zfsRnRd1N49Lw0GFuMhy0YA6LU
         yquPg+7IGO5UKMrIKxttrAEdV4Yx0cTczqTIqwFcqll39IYzZH7iS5yTrC+vyEuNxUkh
         awpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hXi9Ggj5DXa5CNhckkeGGVXOmxJktk4U2qFb5wWI8Mo=;
        b=VTf0A6ALu1NIv1U50bxrZDoizHsUS/85/YtZTabdA/AgN6mZhbebyCGedw8wDG3sMv
         glwC0CYeXVXV5GomnxCC0Ig+mROTrn5yCTb3HP+quNdAuVhpQQjv4/pl7B4/a2J5o5OG
         PTM33oWULZLve0bP/HPHh6OZT39F/xlUPAoNcvTkAyFpZWjqOpLwtqjXoKtPIBLLgU1w
         wpYHdTojQ8+CJtMo6d4vCIScags398aF4cI++z8BaQsbHvZh5gZXTQASPxXVgV/vKiHE
         KCcSowUlaJDBF3N5+BrwyqSNUwYDIDl5O6YJTVXRWUQ68kiUPoZZjqqecshk5Bpxyt/n
         yPng==
X-Gm-Message-State: AOAM530NYZRFBbgpYMETbN0+AimoCEhYbpjWvC5Ho8RANQ2/esEg4N4H
        PEKUvKyQ4/cy/pBByfIIzzgQlXupcBdMyaDKVPA=
X-Google-Smtp-Source: ABdhPJycIyx48xxiq467YwvYvdTuAbeMU32H1B/La0xpKfYphu/crP0g5+ns4EPIeIufX9mrV2Pzv83JDT/tPLsRpm0=
X-Received: by 2002:a92:1fd9:: with SMTP id f86mr18182441ilf.250.1597753556686;
 Tue, 18 Aug 2020 05:25:56 -0700 (PDT)
MIME-Version: 1.0
References: <159770500809.3956827.8869892960975362931.stgit@magnolia> <159770506536.3956827.8490982017014132952.stgit@magnolia>
In-Reply-To: <159770506536.3956827.8490982017014132952.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 15:25:45 +0300
Message-ID: <CAOQ4uxghu9w883G7HOYNVtteEnuJwLUTC5CWh0ggoNgohUz44w@mail.gmail.com>
Subject: Re: [PATCH 09/11] xfs: refactor quota timestamp coding
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 1:57 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Refactor quota timestamp encoding and decoding into helper functions so
> that we can add extra behavior in the next patch.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
