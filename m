Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9683D7E8916
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Nov 2023 05:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjKKEC6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Nov 2023 23:02:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjKKEC5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 23:02:57 -0500
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF4D3868;
        Fri, 10 Nov 2023 20:02:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vw6AFnB_1699675368;
Received: from 172.17.2.246(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vw6AFnB_1699675368)
          by smtp.aliyun-inc.com;
          Sat, 11 Nov 2023 12:02:49 +0800
Message-ID: <33d6a487-5913-fefd-2a45-d8d397e6f6ba@linux.alibaba.com>
Date:   Sat, 11 Nov 2023 12:02:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/3] mm: Add folio_fill_tail() and use it in iomap
To:     Matthew Wilcox <willy@infradead.org>,
        Andreas Gruenbacher <agruenba@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        "Darrick J . Wong" <djwong@kernel.org>, gfs2@lists.linux.dev,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org
References: <20231107212643.3490372-1-willy@infradead.org>
 <20231107212643.3490372-3-willy@infradead.org>
 <CAHc6FU550j_AYgWz5JgRu84mw5HqrSwd+hYZiHVArnget3gb4w@mail.gmail.com>
 <ZU5jx2QeujE+868t@casper.infradead.org>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ZU5jx2QeujE+868t@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2023/11/11 01:09, Matthew Wilcox wrote:
> On Thu, Nov 09, 2023 at 10:50:45PM +0100, Andreas Gruenbacher wrote:
>> On Tue, Nov 7, 2023 at 10:27 PM Matthew Wilcox (Oracle)
>> <willy@infradead.org> wrote:
>>> +static inline void folio_fill_tail(struct folio *folio, size_t offset,
>>> +               const char *from, size_t len)
>>> +{
>>> +       char *to = kmap_local_folio(folio, offset);
>>> +
>>> +       VM_BUG_ON(offset + len > folio_size(folio));
>>> +
>>> +       if (folio_test_highmem(folio)) {
>>> +               size_t max = PAGE_SIZE - offset_in_page(offset);
>>> +
>>> +               while (len > max) {
>>> +                       memcpy(to, from, max);
>>> +                       kunmap_local(to);
>>> +                       len -= max;
>>> +                       from += max;
>>> +                       offset += max;
>>> +                       max = PAGE_SIZE;
>>> +                       to = kmap_local_folio(folio, offset);
>>> +               }
>>> +       }
>>> +
>>> +       memcpy(to, from, len);
>>> +       to = folio_zero_tail(folio, offset, to);
>>
>> This needs to be:
>>
>> to = folio_zero_tail(folio, offset  + len, to + len);
> 
> Oh, wow, that was stupid of me.  I only ran an xfstests against ext4,
> which doesn't exercise this code, not gfs2 or erofs.  Thanks for
> fixing this up.

Assuming that is for the next cycle (no rush), I will also test
this patch and feedback later since I'm now working on other
stuffs.

Thanks,
Gao Xiang
