Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03EEA28EEA0
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Oct 2020 10:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgJOIhE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Oct 2020 04:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729723AbgJOIhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 04:37:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42639C061755
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 01:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=NL0EYXPWnAlth8LYGNnGrk1sAA
        LLdNMrOYaG9U6qpiDFw2NILWW3WhJngHyg81cxH8fB8J52B1UqmjtFaOSb+P3KExqnnvY0mqnumbL
        2ym0z8xInPs7++KVQatjYddcAaLLZ7/Okxk5/4YL+ZwTmllM6uwqT/NSU7OkrEGCkvjGjNrsf4vB9
        Lmos0nWvwgUEyxkFvTlBfILgtMSGKQmIfLmQygmHSrk7oaKELf39yaV92n8ooH27yhgb9iJcv5Upx
        yk4FrvEpPBGqWSUpYA6hvWaJdJOuhu/o6HTWJEbqTrtzCxaIsIlKDD53shZ3ATuOuk3Zf9wqorqKP
        zVR8fLtA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSykw-0001u7-Vd; Thu, 15 Oct 2020 08:37:03 +0000
Date:   Thu, 15 Oct 2020 09:37:02 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH V6 07/11] xfs: Check for extent overflow when moving
 extent from cow to data fork
Message-ID: <20201015083702.GG5902@infradead.org>
References: <20201012092938.50946-1-chandanrlinux@gmail.com>
 <20201012092938.50946-8-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012092938.50946-8-chandanrlinux@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
