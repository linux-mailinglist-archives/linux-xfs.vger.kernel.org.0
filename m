Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2E2584604
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jul 2022 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbiG1Smb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jul 2022 14:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232040AbiG1Sm3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 14:42:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D54A7539E;
        Thu, 28 Jul 2022 11:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YMVw7PGgd6fsE5tEOvRJhzbiE0
        r41amSc/PTeqTlw1sOa21kzlUwEyN1tv/R9aDgQ7Zk1j5QkM2KrZMu6R+OWUAJ8ntaxe/S1ZTcQuq
        P7xyEuSM9NXgWDSiSdwX6niOlZOr7smf73grGQyctTIDZ3LNcqNhXfF6flm7Fvofxyx+KBwKKIBW1
        uZJauURZAyA7aDZ+aA2XHaLQYLymDnFe8KC9joCIQqJaO+rcgRhmB65aNgXWy9skNXiBrgfpuv5PF
        mFFye6TWWbKtm9CMoYRdh9bLfsOCGgDdODE05D7wex83LJZnLSPJLt/4268tYaYwgpvzHDzJEQKaF
        tzQwkB3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oH8Sn-00DEJc-Qt; Thu, 28 Jul 2022 18:42:25 +0000
Date:   Thu, 28 Jul 2022 11:42:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] dmlogwrites: skip generic tests when external logdev
 in use
Message-ID: <YuLYkYYrycO1Obwe@infradead.org>
References: <165886492580.1585149.760428651537119015.stgit@magnolia>
 <165886493136.1585149.12462469554668740768.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165886493136.1585149.12462469554668740768.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
