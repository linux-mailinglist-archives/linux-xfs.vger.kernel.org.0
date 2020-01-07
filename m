Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D364B132892
	for <lists+linux-xfs@lfdr.de>; Tue,  7 Jan 2020 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgAGOO4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Jan 2020 09:14:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbgAGOO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 09:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=oxnpZlweeXLARmHVCduVEjYXm
        UJwBFn/mjKd1S1ruyE/f1KsqVMAYNi4126R2k87136Zf7rsPQ3OPiJRaF6kCLpVghkznvYh61U1ND
        rZFIKZ+pXRN7d457Y0epgijxxv9boY7tBc148WZRYPGYlPjCrXXTZ/857wZSxI8NLKQAKK+bQ7lqp
        FMKlckYZSt+TlPlEPUsOlWKiHSJYX7XHiL16NZ9LYKneZAIV05xfUHI0PLO5c6DrOGI3mofkPSifJ
        UmGdJK2taBGyo0+giVGNT3iEDiYCyFIqWWnXHIesRAF2qTr7si5V4JKnsK3ijvvBPtD+zbtq6ocBR
        oDOfYhusg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iopdF-00030g-3t; Tue, 07 Jan 2020 14:14:53 +0000
Date:   Tue, 7 Jan 2020 06:14:53 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Pavel Reichl <preichl@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH v3 2/2] xfs: quota: move to time64_t interfaces
Message-ID: <20200107141453.GA10628@infradead.org>
References: <20200102204058.2005468-1-arnd@arndb.de>
 <20200102204058.2005468-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102204058.2005468-2-arnd@arndb.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
