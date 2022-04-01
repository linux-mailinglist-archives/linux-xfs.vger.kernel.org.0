Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F104EECD9
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Apr 2022 14:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiDAMIo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 Apr 2022 08:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiDAMIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 08:08:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A17A276FB0
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 05:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZUXMt+vHy1v5aeRyPvhUNaWViXdotH1msNi5UvEH37g=; b=41iE0IOAxkzrHAnS4FJyLrJgQ4
        PMzUmyYMnhEs2VRXKASBXjhf8dJrp5RcRTXIvTj/JT4vN7cDZdPu/wU99djOPdNBslVFt5r418y6s
        hJKZrv+MP4KXgHxSuA9qywLMscjfyrM4Su7VZfnhlOfNsUY5oe5HCvrm2KB0ufO7xB9EYhpmxqLr9
        C7AFfbHO9Cb77G8ttMiinppHOQ6rbufj1yn0PmBGaVZL+QDLqg3v/HHqG9DSqp003Rl5kMGj+JvZA
        7ZtVWRstGBeyaXvwEv6nxbgqBqy0VXW0Na3fWfgyLN0YaZ5TDhiecfI22feuHy8cX1fHVfQsSuXQl
        2pDhTQdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naG3K-005aE8-Mg; Fri, 01 Apr 2022 12:06:54 +0000
Date:   Fri, 1 Apr 2022 05:06:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Message-ID: <Ykbq3knPPKCywtqJ@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-9-david@fromorbit.com>
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

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(although due to the bio alloc API changes this won't apply to
mainline as-is).
