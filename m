Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A17248729
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 16:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgHRORl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Aug 2020 10:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbgHRORi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 10:17:38 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20F4C061342
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:17:37 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t13so17691270ile.9
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 07:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+nnxL5NPmwfvlJSTifpdavTDp3iEOsQDLleLsB6BPQ4=;
        b=W7Kchp4xyli12PiZonN06vMt0iCitRjlUO7FSvq6BIbcy5+QHM7BgJNOqX5ip4sGS7
         OD24UkWGfjSPnlXWH/iQlNlTocoCDjuyfEuyUWDBfejUHpuhT15J03qI31N1lCJ5YIOB
         yrpNuPW6kndm6ZD9BJVO084C7CXtx6OL49GNR8AQZYBlPFkjXFEIzPjpYw3Wckgtf7VR
         TTUiH5meDPBfXZ7aMtMuLd+c497yBT0vqJFlbgP3gc+EGbX2WuUESPuyAm3wscoeBp/b
         C3/LZLY+app5TqIJ8wD2p++fzBiHT/BZpFd4fLt3PGahcWVVgZQxhfhHs0Avn1KTnUKm
         h5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+nnxL5NPmwfvlJSTifpdavTDp3iEOsQDLleLsB6BPQ4=;
        b=lRF61JNSq9bew+/ekSEkHv2JLODiPBDg6r11rYpxa2TzHGPskBRvNe0ulr2Ml4L9HJ
         z50ZfdsBV3bQWV6HMcIe/NG0lWuxu6Y41YZ7rinSiKTSih5Jrw2B6nkhrBB/XvqQ0B+s
         L2GuhHFZATTgX6wFQZKiSieds2IFjV+egA/o48B8ha52oUak6q5XCCgIsT9DRFEKI37+
         hn4XC8O6nS/6XG4UpWItj6+u76RnnTylyF2L42pjOPa2rmAqLtCmJQmYDHtfRSe9RrJg
         F4i/Piyt4NI9ZjTykp7cULDiVURplFtsQmbPT4QOUCrt2SOEblt09mQa5022s0zTOhUp
         E7bg==
X-Gm-Message-State: AOAM530DM87VTkwuM3c6LekHyLo2jOra7PZjjNIDJeETPLNNGDUnNHX9
        HC8Zjc1RCKvgET0BnGzBBVXGj/ytr0s7wYTRgjs=
X-Google-Smtp-Source: ABdhPJxjzxpvYrUfwWhSZDDgdfz7FgN9NWAeMK2q5lgOjXik3Fqbvx6PTDegDNWpYUQrccJLGzsNnT1QDqbGEAURMi0=
X-Received: by 2002:a92:da0a:: with SMTP id z10mr17876581ilm.275.1597760256746;
 Tue, 18 Aug 2020 07:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <159770513155.3958786.16108819726679724438.stgit@magnolia> <159770514598.3958786.15730645159608118691.stgit@magnolia>
In-Reply-To: <159770514598.3958786.15730645159608118691.stgit@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 18 Aug 2020 17:17:25 +0300
Message-ID: <CAOQ4uxhm72ef7WEN4O9sz1ZQZvg2FEuEwaMtcAwWuUe12OJPUg@mail.gmail.com>
Subject: Re: [PATCH 02/18] xfs: explicitly define inode timestamp range
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 18, 2020 at 2:23 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Formally define the inode timestamp ranges that existing filesystems
> support, and switch the vfs timetamp ranges to use it.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
