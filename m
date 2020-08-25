Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3FF25227F
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Aug 2020 23:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHYVKz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Aug 2020 17:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgHYVKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 17:10:53 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C4AC061574
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2020 14:10:52 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id d26so10253ejr.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2020 14:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=M61YkM2EGZM7C+AO87egaaUA1bKcbiaDgTY2Z2xt/1E=;
        b=o1+Ga/3+vG4PKIXBhnjvOF5prfySob+Zzq+3ml09CSzQQYHE8gdwHaZliOs5WeEMOB
         /lj8GuMHA6cHpLBbl0GSd6ygzopcZlmiobNRNtMVkUfArhOhKTMdzRo68tIysMk2g3wI
         oW3gGhiDe7ayp4QFEzsQ4a/JGi1OIU5LFBNhb4gTyBatCBFzoOYiCIcpDp+ECDRhqO0O
         W3AdsA/X30hUoEgGVSp5xBi7OvFaRBbJUxCgBqmWzVOXBGYUtcveUOxHTgpYYtl4Y/5S
         xP05ZFF9mbezgLvfhGzrgxYezhbwMsEkvmbxzXRnm8a38IMVmtMpxn6L7n4bv6XrpvBP
         un8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=M61YkM2EGZM7C+AO87egaaUA1bKcbiaDgTY2Z2xt/1E=;
        b=DIvd9TRzG4vVqy8OHU+kUnBfkn6u2xRn920w+Qv0xflgMYEW5TC+c5DoleUlAUzvta
         M8G0jT4nbmr1SZY0jtSSbC7AYmtlKtQ/THRPpXCX/w2Sd8UYAKm3VEhljpuvF/KZ4Fc5
         cTvxq+wLg6x1Nu7CsoAwK9dhYDa9P397CWGahPRs6xpX0/b5uS5uZ/c/6PcftIrt0Z4u
         Ip7ockMhDwLKOpFc8by4cmTiZ/n7jDAjdoCuX2fCWNmppYTn9iquomHSxZX2Z716a7qL
         +teuPZ2GNqsTebF6e18Ecv9x2nhNC3FdvCeSuZ5EuzTyOvx24sbFKqLIU/vuKmOXRGdu
         CwrA==
X-Gm-Message-State: AOAM5318teaia34FNehNGwyyfQ3w+7lXXT/a8q6FhGh7udOFuMliaqqf
        48nUwcqZSMxSngdv8yN6zMYDSL1TWQ==
X-Google-Smtp-Source: ABdhPJyOp2ieRNfsu+2E3EFLqHWekRIAbODJGn+pSjsR3EIrE6WSALeNWEVBKLUkpORtoi46at8l6w==
X-Received: by 2002:a17:906:a085:: with SMTP id q5mr12319275ejy.136.1598389851377;
        Tue, 25 Aug 2020 14:10:51 -0700 (PDT)
Received: from localhost.localdomain ([46.53.251.143])
        by smtp.gmail.com with ESMTPSA id ca3sm157967edb.72.2020.08.25.14.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 14:10:50 -0700 (PDT)
Date:   Wed, 26 Aug 2020 00:10:48 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com
Subject: "signed < sizeof()" bug in xfs_attr_shortform_verify() ?
Message-ID: <20200825211048.GA2162993@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_attr_shortform_verify() contains the following code:


	int64_t size = ifp->if_bytes;
        /*
         * Give up if the attribute is way too short.
         */
        if (size < sizeof(struct xfs_attr_sf_hdr))
                return __this_address;


In general "if (signed < sizeof())" is wrong because of how type
promotions work. Such check won't catch small negative values.

I don't know XFS well enough to know if negative values were excluded
somewhere above the callchain, but maybe someone else does.
