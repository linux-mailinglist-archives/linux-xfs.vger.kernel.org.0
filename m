Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7360E418CFE
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Sep 2021 01:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhIZXKg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 26 Sep 2021 19:10:36 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2900 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhIZXKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Sep 2021 19:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632697737; x=1664233737;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TDOTPmawcYz4rmiMAIYJQQx5dPP35Ldh0mdFUTfrChI=;
  b=ak++SGTJXJHjtj8QwbHXn3zAZVY+7BYQC63ZMZMQrrRu2FOPWU1JLhwg
   EwNV/vGwamcgpsvjdFTl5Z0dW4RiM3/M7zPMerpXoX2tBBzwqEZBAxAwH
   RVuptlDR2Xqak8YtNQQINJIxHKzqwsvQf3Rf7blkIdZTJbENLyc7fXACW
   nPyNSzXSqcYMcTWtyaMMcC89P4PxBngfAGFhMdkepDxdGsKVOyLT0voXl
   gM6jnpnShIFKf4elVhMFyegpfnrWuMYEEQ9hTDdLWbrxeIUoT/HLg6I0M
   J4JlgJbDZKZdGX+Q1uZ5DP4aC3ZvxomWGAjcSAS/KvHUMVLyByjNUEInz
   g==;
X-IronPort-AV: E=Sophos;i="5.85,325,1624291200"; 
   d="scan'208";a="181015787"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 07:08:57 +0800
IronPort-SDR: ICcqwBDFwh80OGx87GM9RFEoejF60p2+6z4E3r4T6MoEbxMVzD5pgo+C3rHqVLR39uOGxyUNSD
 ZbL+IHOPPimjw4rTLZsT0t3ylB8k9p+/0FYqVHO84rM73wmjV/bi1EcXe+XlX7mSsRBLbgioMZ
 pRs+1C9f0ges8vOiWrqmaPhf/oVIeF6bR8WjRafBraZ05DmiUKW628F2ul3D0lmjmel26zB/c6
 QZhBKRLlYDiHEJobb2Q5tHeUyguj44Ttori+O+BbXriAhd+myTTzGu18G0XXmJZAfpWojmttFg
 8PjJ78icnynBcpuHtk4CeJBx
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2021 15:45:05 -0700
IronPort-SDR: jqO9itrV3hJEY/oDIrcoZC4K1L0poyjj5vjzwyeVaehXygmzx9la8mabxfjkfgDpwIOcpE4Tgb
 9RCrSO6yDZ9Fy1HiDS5JCtAsK3QJMvqpsPh2MRa577cy5Od9ruPtM/pQ2vyT91YuDpbKYOr9HA
 fiWyX77jh8yVXBu/os8gfxZ3ePE/yahTJJUz/fy7AV9aEXqHTClgzqKFfc4LD2Y0EcFMUjmosP
 hLWPTPZpNTmcg/1zUQcfxGUdArTKhFMKR93FXcvnm3S7BIzgsawk0Y7h2CipQBWwGgHXhtfpTx
 ccY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2021 16:08:58 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HHhKQ2p2cz1Rvlf
        for <linux-xfs@vger.kernel.org>; Sun, 26 Sep 2021 16:08:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1632697737; x=1635289738; bh=TDOTPmawcYz4rmiMAIYJQQx5dPP35Ldh0md
        FUTfrChI=; b=TmqmtvnUWB/0fOST0cEzXPQ5EjlnNrPpSxR+bjf6UJqZZo55P3D
        FIoK8AI8+hr11KKXdI9k4f+fj7jXDyP+GSOexgk0xQ5mvJef7ZgJvnuC6IfeSIxu
        68YNCNVQ/KNmrGCLycrn5vhJmh7iefjax+lFC53KM9o6w0POibu9PNHkEiXeA9GO
        gl732LcWzZi0+Eh76bIZJ07k9YXnl8VYPQcR6VMWAdskcbLH7wUyZXqpzFX9nOqn
        Q1Syji8+Zfe5lPXeAqSxX7a3Uzh6sEh0tLn4ixpeKfBTVQFKr4wfz9w2ASbpPiGH
        D7WlSzZ0SuLjRdJmxdhMRyEoDIkt+zeXcPA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ohNM2JB8nnEK for <linux-xfs@vger.kernel.org>;
        Sun, 26 Sep 2021 16:08:57 -0700 (PDT)
Received: from [10.89.85.1] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.85.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HHhKL6dDzz1RvTg;
        Sun, 26 Sep 2021 16:08:54 -0700 (PDT)
Message-ID: <5fde9167-6f8b-c698-f34d-d7fafd4219f7@opensource.wdc.com>
Date:   Mon, 27 Sep 2021 08:08:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.1
Subject: Re: [PATCH v3 9/9] mm: Remove swap BIO paths and only use DIO paths
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        David Howells <dhowells@redhat.com>
Cc:     hch@lst.de, trond.myklebust@primarydata.com,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, darrick.wong@oracle.com,
        viro@zeniv.linux.org.uk, jlayton@kernel.org,
        torvalds@linux-foundation.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <YU84rYOyyXDP3wjp@casper.infradead.org>
 <163250387273.2330363.13240781819520072222.stgit@warthog.procyon.org.uk>
 <163250396319.2330363.10564506508011638258.stgit@warthog.procyon.org.uk>
 <2396106.1632584202@warthog.procyon.org.uk>
 <YU9X2o74+aZP4iWV@casper.infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <YU9X2o74+aZP4iWV@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2021/09/26 2:09, Matthew Wilcox wrote:
> On Sat, Sep 25, 2021 at 04:36:42PM +0100, David Howells wrote:
>> Matthew Wilcox <willy@infradead.org> wrote:
>>
>>> On Fri, Sep 24, 2021 at 06:19:23PM +0100, David Howells wrote:
>>>> Delete the BIO-generating swap read/write paths and always use ->swap_rw().
>>>> This puts the mapping layer in the filesystem.
>>>
>>> Is SWP_FS_OPS now unused after this patch?
>>
>> Ummm.  Interesting question - it's only used in swap_set_page_dirty():
>>
>> int swap_set_page_dirty(struct page *page)
>> {
>> 	struct swap_info_struct *sis = page_swap_info(page);
>>
>> 	if (data_race(sis->flags & SWP_FS_OPS)) {
>> 		struct address_space *mapping = sis->swap_file->f_mapping;
>>
>> 		VM_BUG_ON_PAGE(!PageSwapCache(page), page);
>> 		return mapping->a_ops->set_page_dirty(page);
>> 	} else {
>> 		return __set_page_dirty_no_writeback(page);
>> 	}
>> }
> 
> I suspect that's no longer necessary.  NFS was the only filesystem
> using SWP_FS_OPS and ...
> 
> fs/nfs/file.c:  .set_page_dirty = __set_page_dirty_nobuffers,
> 
> so it's not like NFS does anything special to reserve memory to write
> back swap pages.
> 
>>> Also, do we still need ->swap_activate and ->swap_deactivate?
>>
>> f2fs does quite a lot of work in its ->swap_activate(), as does btrfs.  I'm
>> not sure how necessary it is.  cifs looks like it intends to use it, but it's
>> not fully implemented yet.  zonefs and nfs do some checking, including hole
>> checking in nfs's case.  nfs also does some setting up for the sunrpc
>> transport.
>>
>> btrfs, cifs, f2fs and nfs all supply ->swap_deactivate() to undo the effects
>> of the activation.
> 
> Right ... so my question really is, now that we're doing I/O through
> aops->direct_IO (or ->swap_rw), do those magic things need to be done?
> After all, open(O_DIRECT) doesn't do these same magic things.  They're
> really there to allow the direct-to-BIO path to work, and you're removing
> that here.

For zonefs, ->swap_activate() checks that the user is not trying to use a
sequential write only file for swap. Swap cannot work on these files as there
are no guarantees that the writes will be sequential.

-- 
Damien Le Moal
Western Digital Research
