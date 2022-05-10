Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06925210EC
	for <lists+linux-xfs@lfdr.de>; Tue, 10 May 2022 11:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiEJJfm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 10 May 2022 05:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238521AbiEJJfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 05:35:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C382A28F7D2
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 02:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D5YFAp8YT8jyPSO3W+/1VNd2vV/4HS5/EnkTJmKP9CY=; b=nyWUwdAzHDttWadIjgHcXSBIai
        b/jw7faJKrYU6l7CbFEbbZb5R6ZM5nriQUpdgfvxMgFcrkAppNj+D63Y7QF3QHjYebtfjSBJV3SK+
        j8sX4qv9brQZXa5YTWLM31XzjG3jXjO0AGnSfiFZwG+7BttwxQeq99XGLcTP6KBFijmOG3VNQPWOW
        dysjYPflhyXdWSzv8CVxHLyjdBpsFOyUFXqTWwsE4IjN8evFwKdnl52cJC6uQIi+ppjBEmybzKT0y
        whmI3sVycByQT0ED8qPWkn+E8LyDTSCXaVSbpTpUeCTGrwYY103XPod/LhZSchW54CI0GnQWDnhrE
        FMviat7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMDY-000qFI-EX; Tue, 10 May 2022 09:31:44 +0000
Date:   Tue, 10 May 2022 02:31:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] io/mmap.c: fix musl build on mips64
Message-ID: <YnoxAFYCYfAvSKp2@infradead.org>
References: <20220508193029.1277260-1-fontaine.fabrice@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508193029.1277260-1-fontaine.fabrice@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and another example of why the old rule of thumb to always include
system headers before local ones is a good idea)

