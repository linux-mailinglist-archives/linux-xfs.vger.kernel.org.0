Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD481D71E6
	for <lists+linux-xfs@lfdr.de>; Mon, 18 May 2020 09:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgERHcu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 May 2020 03:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgERHcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 03:32:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EFBC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 00:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=z5Fg4LFd74C2IVdoCFLYhu/gO4dv37T3w3na6I4zgy4=; b=kheYAPnw4CmMny8xGRAhyaeCgc
        D8rplYabpVVJf37wsA+sPZ2QiiZOCQR3my3XAP9Wsk9ACRnjbMSZToJpq6GJtvabaIBjUkrS+K7Rl
        bTK4Y0N39Q5UhlkGn7M/dbD/OotN6aF/H9NHzNEZl0F0IFiduXfRH6KC3Amp6sIv+0J6VlFPb/63C
        f6wl/js+QwB8FtmGQqpKWQ/2MjI1npVrHIsQj3RItcqws5YRE9N+kHRsCZrTSMv53H6WJm46US4KR
        XSGf+5DVc6re+9ysMwDDQKMJKUzB3KbQIQ7cltx/Xbuxnwib0Ei9HstgSdigNFKzFN/x0IH0dPme2
        hDApN1xA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jaaGU-0002VO-77; Mon, 18 May 2020 07:32:46 +0000
Date:   Mon, 18 May 2020 00:32:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [ANNOUNCE] xfsprogs for-next updated to 5d0807ad
Message-ID: <20200518073246.GA7973@infradead.org>
References: <ec63ae12-41b0-26e7-0a60-72820f7385c6@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec63ae12-41b0-26e7-0a60-72820f7385c6@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Btw, some time after xfsprogs 5.6, xfstests generic/590 start to fail
with new xfs_check errors in the form of:

rtblock 1048576 beyond end of expected area
rtblock 1048576 beyond end of expected area
rtblock 1048580 beyond end of expected area
rtblock 1048580 beyond end of expected area
rtblock 1048584 beyond end of expected area
rtblock 1048584 beyond end of expected area
rtblock 1048588 beyond end of expected area
rtblock 1048588 beyond end of expected area
rtblock 1048592 beyond end of expected area
rtblock 1048592 beyond end of expected area
rtblock 1048596 beyond end of expected area
rtblock 1048596 beyond end of expected area
rtblock 1048600 beyond end of expected area


