Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F2C4FFAB7
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Apr 2022 17:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234659AbiDMP5I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Apr 2022 11:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiDMP5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 11:57:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07C5205E3
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Cc7PVhKLwsYZkma7MBtyeTc8gZO7u4wafKIQ9kY0Xh0=; b=YmoCSWmKul5ag+icVgVFBwqgRJ
        Qi16+X77dJGGqv5gjS1Ji+t2THThiyDqfA4TrHadCCLs/+cgeXbDLFGDZCZ6uuI1ty2TN9YZsvO3s
        Xqq6R4iJFprKWzynXm1HULGruyseVa98J8V/7wgTVhYvOLqmAT63dD6l5Wy5j0loW5StVvOZq5Uiz
        oH3CaXZUEBnlZdpOr1t1euMdscV7wxWJUhQWVxweK15ULCBFuDMHCvoL1kAwDP1Aq5Lz+xCP0+0z/
        iKK0pn7DiYARk7ftdp/hFZEg8L1ymzJP+8u1KzYrGOgnK4MXfAC/abgCIRKYDZYuadhwx7lFT4ESq
        A002CaRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nefKO-001g0G-FY; Wed, 13 Apr 2022 15:54:44 +0000
Date:   Wed, 13 Apr 2022 08:54:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_quota: split get_quota() and
 report_mount()/dump_file()
Message-ID: <YlbyRFlTZa18mIgB@infradead.org>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-4-aalbersh@redhat.com>
 <Yk3Bp4rPbukT9VC7@infradead.org>
 <Yk7F0CM+DKf2wEYA@aalbersh.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk7F0CM+DKf2wEYA@aalbersh.remote.csb>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 07, 2022 at 01:06:56PM +0200, Andrey Albershteyn wrote:
> I did it like this initially but it appeared to me that the diff was
> messy. As there were many &d -> d and report_mount ->
> get_quota/report_mount replacements, so I split it. But I'm not
> against reshaping this back, should I do it?

Well, a large part of this series is churn and we can't do much about
it.  To me doing the changes together seems more logical, but in the
end either way is fine, so feel free to do it the way you prefer.
